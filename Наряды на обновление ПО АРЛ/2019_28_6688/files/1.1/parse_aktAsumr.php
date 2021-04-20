<?	
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	// ��������� ��������� �� ������ ��, ������� �� ��� ��
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	//==========================================================================================
	function parse_aktAsumr(&$params) {
		try {
			$params['station'] = $params['body']['station'];
			
			$dt = -1;
			if ($params['type'] == 'asumrstart') $dt = 0;
			if ($params['type'] == 'asumrend')	 $dt = 1;
			
			if ($dt < 0) throw new Exception ("�� ������� ���������� ��� ��� (������/���������).");
			$arr_in = $params['body'];
			$arr_in['dt'] = $dt;
			
						
			$aofId = create_aof_mr($arr_in);
			if($aofId)	{
				//����
				$obj = new stdClass;
				$obj->aofId 	= $aofId;
				$obj->carriage 	= $arr_in['carriage'];
				to_VagModel_que($params['type'],$obj);
				
				//��� � ������ �������
				to_que_list($params, $aofId, "");
			}
		}
		catch (Exception $e) {
			$err = mssql_get_last_message();
			$rez = $e->getMessage();
			throw new Exception(to_utf8($rez));
		}
	}

	//==========================================================================================
	//�������� ������� �������� ����
	function create_aof_mr($input) {
		if (!array_key_exists('tgnl',$input) || !is_numeric($input['tgnl']))
			throw new Exception ('�� ������� ����.');
		
		$tgnl = $input['tgnl'];
		$stCode = $input['station'];
		
		// ������������ ������ ������� �� ��� ��
		$a_Cars = []; $TypeAdd = false;
		foreach ($input['carriage'] as $car) {
			if ($car['number'] && !array_key_exists($car['number'],$a_Cars))
				$a_Cars[] = $car['number'];
		}
		// ������ ����� �� ������� �������
		$ship = ask_etran($a_Cars,'vag',1);
		if (count($ship) == 1 && isset($ship[0]['err']))
			throw new Exception ( "������ �� �����: ".$ship[0]['err'] );
		if (!count($ship))
			throw new Exception ("�� ����� �� �������� ������ � �������.");
		
		$aof = [];
		
		// ������� ���������� ��� ���
		switch ((int)$input['type']) {
			case 1:  //�� ����������� � ���������� �� ������ ������
				$dogType = SearchInTRPP($tgnl,$stCode);
				if (!$dogType)
					$TypeAdd = 1218;
				else if ($dogType == 2)
					$TypeAdd = 1219; 
				else if (in_array($dogType, [1,3,7]))
					$TypeAdd = 1220; 
				else throw new Exception ("��� �������� dogType = $dogType ��� TGNL = $tgnl - �� ��������.");
				
				$aof['responce'] = 'r';
				$aof['infrastructure'] = array();
				$aof['infrastructure']['asumrType']		= $input['type'];
				$aof['infrastructure']['asumrTGNL']		= $tgnl;
				$aof['infrastructure']['asumrWayID']	= $input['way'];
				$aof['infrastructure']['gu2aDate']		= DateParse($input['datenotice'],'', '79, datenotice');
			break;
				
			case 2: //�� �������� ������ �� ��� �� �������� ��������
				$ch_ship = CheckInShipment($ship,$tgnl,count($a_Cars));
				if ($ch_ship['fault'] == 'S') {$TypeAdd = 1223; $aof['responce'] = 's';}
				if ($ch_ship['fault'] == 'R') {$TypeAdd = 1224; $aof['responce'] = 'r';}
				
				$req['aof']['overcontract'] = array();
				$req['aof']['overcontract']['asumrType']	= $input['type'];
				$req['aof']['overcontract']['asumrTGNL']	= $tgnl;
				$req['aof']['overcontract']['asumrWayID']	= $input['way'];
				$req['aof']['overcontract']['popWayDate']	= DateParse($input['datepod'],'', '91, datepod');
			break;
				
			case 3: //�� �������� ������ �� ��� �� �������� ��������
				$ch_ship = CheckInShipment($ship,$tgnl,count($a_Cars));
				if ($ch_ship['fault'] == 'S') {$TypeAdd = 1225; $aof['responce'] = 's';}
				if ($ch_ship['fault'] == 'R') {$TypeAdd = 1226; $aof['responce'] = 'r';}
				
				$aof['infrastructure'] = array();
				$aof['infrastructure']['asumrType']		= $input['type'];
				$aof['infrastructure']['asumrTGNL']		= $tgnl;
				$aof['infrastructure']['asumrWayID']	= $input['way'];
			break;
				
			default: 
				throw new Exception ("�� ������� ��� ���� (arr_in->type).");
		}
		
		$dt = $input['dt'];
		// �������� ������ ���� � ����������� �� ���� ����
		$dateFiled = ($dt == 1) ? 'dateend' : 'datestart';
		
		$aofDate = trim($input[$dateFiled]);
		if (!$aofDate)
			throw new Exception ("��� ���� ��� �������� ����. $dateFiled is empty.");
		check_date_for_aof($aofDate);
		
		$aofDate = checkDateParse($aofDate);
		if (!$aofDate)
			throw new Exception ("��� ���� ��� �������� ����. $dateFiled is empty(parsed).");
		
		// ���� ��� �� ������ - �������� 2 ����
		if ($dt == 0) $aofDate->add(new DateInterval("PT2H"));
		
		$aofDate = $aofDate->format('Y-m-d H:i:s');
		
		$aof['aofDate'] = $aof['eventDateTime'] = $aofDate;
		$aof['aofStation'] 		= $stCode;
		$aof['aofReason'] 		= $TypeAdd;
		$aof['aofOwner'] 		= 0;
		$aof['downtimeBeginEnd'] = $dt;
		$aof['force_save'] = 1; // ��
		$aof['carriage'] = $ship;

		$result = create_aof_byCar(['aof' => $aof]);						
		if (gettype($result) != 'object')
			throw new Exception ('�� ������� ������� ���. ������ �������� ���.');
			
		if ($result->verify == 'ok' && $result->aofId) {
			return $result->aofId;
		}
		else throw new Exception ("�� ������� ������� ���. ������ �������� ���:<br>".$result->verify);
		
		
	
	}

	//==========================================================================================
	// ����� ���� � ������ ��������, ���������� �� �� ����� 
	function CheckInShipment($ship,$tgnl,$countCars) {
		// R - reciever, S - sender, N - nobody
		$a = [ 'fault' => '', 'R' => [], 'S' => [], 'N' => [] ];
		foreach($ship as $dataCar) {
			foreach ($dataCar['shipment'] as $dataSend) {
				if ($tgnl == $dataSend['send']['senderTGNL']) {
					$a['S'][] = $dataCar['carNum'];
				}
				else if ($tgnl == $dataSend['send']['recieverTGNL']) {
					$a['R'][] = $dataCar['carNum'];
				}
				else $a['N'][] = $dataCar['carNum'];
			}
		}
		$a['R'] = array_unique($a['R']);
		$a['S'] = array_unique($a['S']);
		
		if (count($a['N']))
			throw new Exception ('� ������� '.implode(',',$a['N']).' �� ������� ���������� ��� ��� �� ���� �����������/����������.');
		if (count($a['S']) && count($a['R']))
			throw new Exception ('����� ������� '.implode(',',$a['S']).' - �����������, ����� '.implode(',',$a['R']).' - ����������.');
		
		if ($countCars == count($a['R']))
			$a['fault'] = 'R';
		if ($countCars == count($a['S']))
			$a['fault'] = 'S';
		
		return $a;
	}

	//==========================================================================================
	//����� ���� � ���� ��������� �� �� �����
	function SearchInTRPP($tgnl,$stCode){
		if (!$tgnl || !is_numeric($tgnl) || !$stCode) return !1;
		global $con_arg;
		$res = sql_query("
			SELECT DISTINCT ISNULL(dogType,-1) dogType
			FROM arg.dbo.T_ReceiverPP
			WHERE actual = 1 AND TGNL = $tgnl AND station = '{$stCode}'
		",$con_arg);
		$r = sql_fetch_assoc($res);
		return isset($r['dogType'])? $r['dogType'] : !1;
		
	}
?>