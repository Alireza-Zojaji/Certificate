$(document).ready( async function(){
	var metamask = false;
	if (window.ethereum) {
		window.web3 = new Web3(ethereum);
		metamask = true;
		try {
			await ethereum.enable();
			accounts= await web3.eth.getAccounts();
			option={from: accounts[0] };
		} catch (error) {
			// User denied account access...
		}
	}
	// Legacy dapp browsers...
	else if (window.web3) {
		window.web3 = new Web3(web3.currentProvider);
		metamask = true;
		// Acccounts always exposed
		try {
			web3.eth.defaultAccount = web3.eth.accounts[0];
			option = {from: web3.eth.accounts[0]}
		} catch (error) {
			
		}
		web3.eth.sendTransaction({/* ... */});
	}
	// Non-dapp browsers...
	else {
		web3 = new Web3(new Web3.providers.HttpProvider(inforaUrl));
		var account = web3.eth.accounts.create();
		option = {from: account.address};
	}
	CryptoClass = new web3.eth.Contract(abi,contractAddress);
	message(web3.version,);
//	if (metamask)
//		var options = {from : web3.eth.accounts[0]};
//	else
//		var option = {from: address}; //from : '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe'

	$('#showInstitute').click(function(){
		message('');
		CryptoClass.methods.GetInstitute().call(option,function(error,result){
			if (! error) {
				message(expand(result));
			}
			else
				message(error);
		});
	});
	$('#showAdminStats').click(function(){
		message('');
		CryptoClass.methods.GetAdminStats().call(option,function(error,result){
			if (! error) {
				message(expand(result));
			}
			else
				message(error);
		});
	});
	$('#showStats').click(function(){
		message('');
		CryptoClass.methods.GetStats().call(option,function(error,result){
			if (! error) {
				message(expand(result));
			}
			else
				message(error);
		});
	});
	$('#registerInstructor').click(function(){
		message('');
		CryptoClass.methods.RegisterInstructor($('#instructorUId').val(),$('#instructor').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#showInstructors').click(function(){
		message('');
		CryptoClass.methods.GetInstructors().call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#showInstructorInfo').click(function(){
		message('');
		CryptoClass.methods.GetInstructor($('#instructorUId1').val()).call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#showInstructorCourses').click(function(){
		message('');
		CryptoClass.methods.GetInstructorCourses($('#instructorUId2').val()).call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#registerCourse').click(function(){
		message('');
		CryptoClass.methods.RegisterCourse(
			$('#courseUId').val(),
			$('#courseName').val(),
			$('#startDate').val(),
			$('#endDate').val(),
			$('#duration').val(),
			$('#instructorId').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#showCourses').click(function(){
		message('');
		CryptoClass.methods.GetCourses().call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#addInstructor').click(function(){
		message('');
		CryptoClass.methods.AddCourseInstructor(
			$('#courseId1').val(),
			$('#InstructorId2').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#showCourseInfo').click(function(){
		message('');
		CryptoClass.methods.GetCourseInfo(
			$('#courseUId1').val())
			.call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#showCourseStudents').click(function(){
		message('');
		CryptoClass.methods.GetCourseStudents(
			$('#instructorUId3').val(),
			$('#courseUId2').val())
			.call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#registerStudent').click(function(){
		message('');
		CryptoClass.methods.RegisterStudent(
			$('#studentUId').val(),
			$('#studentName').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#showStudents').click(function(){
		message();
		CryptoClass.methods.GetStudents().call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#showStudentInfo').click(function(){
		message();
		CryptoClass.methods.GetStudentInfo(
			$('#studentUId1').val())
			.call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#registerCertificate').click(function(){
		message('');
		CryptoClass.methods.RegisterCertificate(
			$('#certificateUId').val(),
			$('#courseId').val(),
			$('#instructorId1').val(),
			$('#CertificateType').val(),
			$('#result1').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#showCertificates').click(function(){
		message('');
		CryptoClass.methods.GetCertificates().call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#showCertificate').click(function(){
		message('');
		CryptoClass.methods.GetCertificate(
			$('#certificateUId1').val())
			.call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#enableCertificate').click(function(){
		message('');
		CryptoClass.methods.EnableCertificate(
			$('#certificateUId2').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#disableCertificate').click(function(){
		message('');
		CryptoClass.methods.DisableCertificate(
			$('#certificateUId2').val())
			.send(option,function(error,result){
			if (! error)
				message(result);
			else
				message(error);
		});
	});
	$('#showStudentCertificates').click(function(){
		message('');
		CryptoClass.methods.GetStudentCertificates(
			$('#studentUId2').val())
			.call(option,function(error,result){
			if (! error)
				message(expand(result));
			else
				message(error);
		});
	});
	$('#randomInstructorUId').click(function(){
		$('#instructorUId').val(getUId());
	});
	$('#randomCourseUId').click(function(){
		$('#courseUId').val(getUId());
	});
	$('#randomStudentUId').click(function(){
		$('#studentUId').val(getUId());
	});
	$('#randomCertificateUId').click(function(){
		$('#certificateUId').val(getUId());
	});
});
expand =  function(jsonStr) {
	jsonStr = web3.utils.hexToAscii(web3.utils.utf8ToHex(jsonStr));
	var jsonObj = JSON.parse(jsonStr);
	str = '';
	
	if (isObject(jsonObj)) {
		expandObject(jsonObj);
	}
	else if (isArray(jsonObj)) {
		expandArray(jsonObj);
	}
	return(str);
}
expandArray = function(x) {
	var j;
	for (i in x) {
		str +=  (1+parseInt(i)) + ': ';
		if (isObject(x[i])) {
			str += '<br/>';
			str += '==========';
			str += '<br/>';
			expandObject(x[i]);
			str += '==========';
			str += '<br/>';
		}
		else if (isArray(x[i])) {
			str += '<br/>';
			str += '==========';
			str += '<br/>';
			expandArray(x[i]);
			str += '==========';
			str += '<br/>';
		}
		else {
			str += x[i];
			str += '<br/>';
		}
	}
}
expandObject = function(x) {
	for (i in x) {
		str += i + ': ';
		var newRow = true;
		if (isObject(x[i])) {
			if (newRow) {
				str += '<br/>';
				newRow = false;
			}
			str += '==========';
			str += '<br/>';
			expandObject(x[i]);
			str += '==========';
			str += '<br/>';
		}
		else if (isArray(x[i])) {
			if (newRow) {
				str += '<br/>';
				newRow = false;
			}
			str += '==========';
			str += '<br/>';
			expandArray(x[i]);
			str += '==========';
			str += '<br/>';
		}
		else {
			str += x[i];
			str += '<br/>';
		}
	}
}
function isObject(v) {
	return (typeof v === 'object' && v instanceof Object && !(v instanceof Array) && v !== null);
}
function isArray(v) {
	return (v instanceof Array && !!v);
}
message = function(x){
	$("#result",parent.document).contents().find('#cResult').html(x);
};
function getUId() {
	var str = '';
	for (var i = 1; i <= 3; i++ )
		str += (1 + Math.floor(9 * Math.random()));
	for (i = 1; i <= 3; i++ ) 
		str += String.fromCharCode(65 + Math.floor(26 * Math.random()));
	for (var i = 1; i <= 4; i++ )
		str += (1 + Math.floor(9 * Math.random()));
	return(str);
}