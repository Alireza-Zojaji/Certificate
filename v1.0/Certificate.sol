pragma solidity ^0.4.25;
contract CryptoClassCertificate {
    bytes32 Institute;
    address owner;
    mapping(uint => bytes) Instructor;
    uint InstructorCount = 0;
    struct course {
        bytes10 CourseNumber;
        bytes CourseName;
        bytes10 StartDate;
        bytes10 EndDate;
        uint Hours;
        uint InstructorId;
    }
    mapping(uint => course) Course;
    uint CourseCount = 0;
    struct student {
        bytes32 Name;
        bytes10 NationalId;
        bytes15 FatherName;
    }
    mapping(uint => student) Student;
    uint StudentCount = 0;
    struct certificate {
        uint CourseId;
        uint StudentId;
        uint CertificateType;
        bytes10 Result;
        bool Enabled;
    }
    mapping(bytes10 => certificate) Certificate;
    uint CertificateCount = 0;
    bytes10[] CertificateIds;
    modifier onlyOwner() {
        require(msg.sender==owner);
        _;
    }
    modifier notEmpty(string str) {
        bytes memory bStr = bytes(str);
        require(bStr.length > 0);
        _;
    }
    modifier isPositive(uint number) {
        require(number > 0);
        _;
    }
    modifier haveInstructor(uint InstructorId) {
        require(Instructor[InstructorId].length > 0);
        _;
    }
    modifier haveCourse(uint CourseId) {
        require(Course[CourseId].CourseName.length > 0);
        _;
    }
    modifier haveStudent(uint StudentId) {
        require(Student[StudentId].Name.length > 0);
        _;
    }
    modifier notRepeatedCertId(string certificateId) {
        bytes10 cert_id=bytes10(stringToBytes32(certificateId));
        require(Certificate[cert_id].Result == "");
        _;
    }
    constructor(string _Institute) public notEmpty(_Institute) {
        owner = msg.sender;
        Institute = stringToBytes32(_Institute);
    }
    function GetInstitute() public view returns(string) {
        uint[1] memory pointer;
        pointer[0]=0;
        bytes memory institute=new bytes(32);
        copyBytesNToBytes(Institute, institute, pointer);
        return(string(institute));
    }
    function RegisterInstructor(string _Instructor) public onlyOwner notEmpty(_Instructor) {
        InstructorCount++;
        Instructor[InstructorCount] = bytes(_Instructor);
    }
    function GetInstructors() public view onlyOwner returns(string) {
        uint len = 0;
        uint i;
        for (i=1 ; i <= InstructorCount ; i++)
            len += 1 + Instructor[i].length;
        bytes memory instructors = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        for (i=1 ; i <= InstructorCount ; i++) {
            copyBytesToBytes(Instructor[i], instructors, pointer);
            copyBytesNToBytes('\n', instructors, pointer);
        }
        return(string(instructors));
    }
    function RegisterCourse(
        string CourseNumber,
        string CourseName,
        string StartDate,
        string EndDate,
        uint Hours,
        uint InstructorId
        ) public onlyOwner notEmpty(CourseNumber) notEmpty(CourseName) isPositive(Hours) haveInstructor(InstructorId) {
            course memory _course = setCourseElements(CourseNumber, CourseName, StartDate, EndDate);
            _course.Hours = Hours;
            _course.InstructorId = InstructorId;
            CourseCount++;
            Course[CourseCount]=_course;
    }
    function setCourseElements(
        string CourseNumber,
        string CourseName,
        string StartDate,
        string EndDate
        ) internal pure returns(course) {
        course memory _course;
        _course.CourseNumber = bytes10(stringToBytes32(CourseNumber));
        _course.CourseName = bytes(CourseName);
        _course.StartDate = bytes10(stringToBytes32(StartDate));
        _course.EndDate = bytes10(stringToBytes32(EndDate));
        return(_course);
    }
    function GetCourseInfo(string CourseNumber) public view notEmpty(CourseNumber) returns(string) {
        bytes10 _courseNumber=bytes10(stringToBytes32(CourseNumber));
        bool found = false;
        for (uint i=1; i<=CourseCount; i++) {
            if (Course[i].CourseNumber == _courseNumber) {
                found = true;
                uint len = 100;
                len += Institute.length + 10 + Course[i].CourseName.length + 10 + 10 + Instructor[Course[i].InstructorId].length;
                bytes memory courseInfo = new bytes(len);
                uint[1] memory pointer;
                pointer[0]=0;
                copyBytesNToBytes('Issuer: ', courseInfo, pointer);
                copyBytesNToBytes(Institute, courseInfo, pointer);
                copyBytesNToBytes('\nCourse Id: ', courseInfo, pointer);
                copyBytesNToBytes(_courseNumber, courseInfo, pointer);
                copyBytesNToBytes('\nCourse Name: ', courseInfo, pointer);
                copyBytesToBytes(Course[i].CourseName, courseInfo, pointer);
                copyBytesNToBytes('\nStart date: ', courseInfo, pointer);
                copyBytesNToBytes( Course[i].StartDate, courseInfo, pointer);
                copyBytesNToBytes("\nEnd date: ", courseInfo, pointer);
                copyBytesNToBytes( Course[i].EndDate, courseInfo, pointer);
                copyBytesNToBytes("\nDuration: ", courseInfo, pointer);
                copyBytesNToBytes( uintToBytesN(Course[i].Hours), courseInfo, pointer);
                copyBytesNToBytes(" Hours\n", courseInfo, pointer);
                return(string(courseInfo));
            }
        require(found);
        }
    }
    function GetJsonCourseInfo(string CourseNumber) public view notEmpty(CourseNumber) returns(string) {
        bytes10 _courseNumber=bytes10(stringToBytes32(CourseNumber));
        bool found = false;
        for (uint i=1; i<=CourseCount; i++) {
            if (Course[i].CourseNumber == _courseNumber) {
                found = true;
                uint len = 100;
                len += Institute.length + 10 + Course[i].CourseName.length + 10 + 10 + Instructor[Course[i].InstructorId].length;
                bytes memory courseInfo = new bytes(len);
                uint[1] memory pointer;
                pointer[0]=0;
                copyBytesNToBytes('{"Issuer":"', courseInfo, pointer);
                copyBytesNToBytes(Institute, courseInfo, pointer);
                copyBytesNToBytes('","CourseId":"', courseInfo, pointer);
                copyBytesNToBytes(_courseNumber, courseInfo, pointer);
                copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
                copyBytesToBytes(Course[i].CourseName, courseInfo, pointer);
                copyBytesNToBytes('","StartDate":"', courseInfo, pointer);
                copyBytesNToBytes( Course[i].StartDate, courseInfo, pointer);
                copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
                copyBytesNToBytes( Course[i].EndDate, courseInfo, pointer);
                copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
                copyBytesNToBytes( uintToBytesN(Course[i].Hours), courseInfo, pointer);
                copyBytesNToBytes('"}', courseInfo, pointer);
                return(string(courseInfo));
            }
        require(found);
        }
    }
    function GetCourses() public view onlyOwner returns(string) {
        uint len = 0;
        uint i;
        for (i=1 ; i <= CourseCount ; i++)
            len += 6 + 8 + Course[i].CourseName.length + 12 + 12 + 6 + Instructor[Course[i].InstructorId].length;
        bytes memory courses = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        bytes32 hrs;
        for (i=1 ; i <= CourseCount ; i++) {
            copyBytesNToBytes(Course[i].CourseNumber, courses, pointer);
            copyBytesNToBytes(',', courses, pointer);
            copyBytesToBytes(Course[i].CourseName, courses, pointer);
            copyBytesNToBytes(',', courses, pointer);
            copyBytesToBytes(Instructor[Course[i].InstructorId], courses, pointer);
            copyBytesNToBytes(',', courses, pointer);
            copyBytesNToBytes(Course[i].StartDate, courses, pointer);
            copyBytesNToBytes(',', courses, pointer);
            copyBytesNToBytes(Course[i].EndDate, courses, pointer);
            copyBytesNToBytes(',', courses, pointer);
            hrs = uintToBytesN(Course[i].Hours);
            copyBytesNToBytes(hrs, courses, pointer);
            copyBytesNToBytes(' Hours\n', courses, pointer);
        }
        return(string(courses));
    }
    function RegisterStudent(
        string Name,
        string NationalId,
        string FatherName
        ) public onlyOwner notEmpty(Name) notEmpty(NationalId) notEmpty(FatherName) {
            student memory _student;
            _student.Name = stringToBytes32(Name);
            _student.NationalId = bytes10(stringToBytes32(NationalId));
            _student.FatherName = bytes15(stringToBytes32(FatherName));
            StudentCount++;
            Student[StudentCount]=_student;
    }
    function GetStudents() public view onlyOwner returns(string) {
        uint len = 0;
        uint i;
        for (i=1 ; i <= StudentCount ; i++)
            len += 3 + Student[i].Name.length + 10 + Student[i].FatherName.length;
        bytes memory students = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        for (i=1 ; i <= StudentCount ; i++) {
            copyBytesNToBytes(Student[i].NationalId, students, pointer);
            copyBytesNToBytes(',', students, pointer);
            copyBytesNToBytes(Student[i].Name, students, pointer);
            copyBytesNToBytes(',', students, pointer);
            copyBytesNToBytes(Student[i].FatherName, students, pointer);
            copyBytesNToBytes('\n', students, pointer);
        }
        return(string(students));
    }
    function RegisterCertificate(
        string CertificateId,
        uint CourseId,
        uint StudentId,
        uint CertificateType,
        string Result
        ) public onlyOwner haveStudent(StudentId) haveCourse(CourseId) notRepeatedCertId(CertificateId) isPositive(CertificateType) {
            certificate memory _certificate;
            _certificate.CourseId = CourseId;
            _certificate.StudentId = StudentId;
            _certificate.CertificateType = CertificateType;
            _certificate.Result = bytes10(stringToBytes32(Result));
            _certificate.Enabled = true;
            bytes10 cert_id = bytes10(stringToBytes32(CertificateId));
            Certificate[cert_id] = _certificate;
            CertificateIds.push(cert_id);
            CertificateCount++;
    }
    function GetCertificates() public view onlyOwner returns(string) {
        uint len = 0;
        uint i;
        len = CertificateCount * (1 + 10);
        bytes memory certificates = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        for (i=0 ; i < CertificateCount ; i++) {
            copyBytesNToBytes(CertificateIds[i], certificates, pointer);
            copyBytesNToBytes('\n', certificates, pointer);
        }
        return(string(certificates));
    }
    function GetCertificate(string memory CertificateId) public view notEmpty(CertificateId) returns(string) {
        bytes memory certSpec;
        uint len;
        uint[1] memory pointer;
        pointer[0] = 0;
        len = 500;
        len += Course[_certificate.CourseId].CourseName.length+
            Instructor[Course[_certificate.CourseId].InstructorId].length;
        certSpec = new bytes(len);
        bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
        certificate memory _certificate = Certificate[_certificateId];
        require(_certificate.Enabled);
        course memory _course = Course[_certificate.CourseId];
        student memory _student = Student[_certificate.StudentId];
        copyBytesNToBytes('Issuer: ', certSpec, pointer);
        copyBytesNToBytes(Institute, certSpec, pointer);
        copyBytesNToBytes('\nCertificate Id: ', certSpec, pointer);
        copyBytesNToBytes(_certificateId, certSpec, pointer);
        copyBytesNToBytes('\nName: ', certSpec, pointer);
        copyBytesNToBytes(_student.Name, certSpec, pointer);
        copyBytesNToBytes('\nNational Id: ', certSpec, pointer);
        copyBytesNToBytes( _student.NationalId, certSpec, pointer);
        copyBytesNToBytes("\nFather's name: ", certSpec, pointer);
        copyBytesNToBytes(_student.FatherName, certSpec, pointer);
        copyBytesNToBytes('\nCourse Id: ', certSpec, pointer);
        copyBytesNToBytes(_course.CourseNumber, certSpec, pointer);
        copyBytesNToBytes('\nCourse name: ', certSpec, pointer);
        copyBytesToBytes(_course.CourseName, certSpec, pointer);
        copyBytesNToBytes('\nStarted at: ', certSpec, pointer);
        copyBytesNToBytes(_course.StartDate, certSpec, pointer);
        copyBytesNToBytes('\nEnded at: ', certSpec, pointer);
        copyBytesNToBytes(_course.EndDate, certSpec, pointer);
        copyBytesNToBytes('\nDurationHours: ', certSpec, pointer);
        copyBytesNToBytes(uintToBytesN(_course.Hours), certSpec, pointer);
        copyBytesNToBytes('\nInstructor(s): ', certSpec, pointer);
        copyBytesToBytes(Instructor[_course.InstructorId], certSpec, pointer);
        uint CertificateType = _certificate.CertificateType;
        bytes10 _certType;
        if (CertificateType == 1)
            _certType = 'Attendance';
        else if (CertificateType == 2)
            _certType = 'Online';
        else if (CertificateType == 3)
            _certType = 'Video';
        copyBytesNToBytes('\nCourse type: ', certSpec, pointer);
        copyBytesNToBytes(_certType, certSpec, pointer);
        copyBytesNToBytes('\nResult: ', certSpec, pointer);
        copyBytesNToBytes(_certificate.Result, certSpec, pointer);
        return(string(certSpec));
    }
    function GetJsonCertificate(string memory CertificateId) public view notEmpty(CertificateId) returns(string) {
        bytes memory certSpec;
        uint len;
        uint[1] memory pointer;
        pointer[0] = 0;
        len = 500;
        len += Course[_certificate.CourseId].CourseName.length+
            Instructor[Course[_certificate.CourseId].InstructorId].length;
        certSpec = new bytes(len);
        bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
        certificate memory _certificate = Certificate[_certificateId];
        require(_certificate.Enabled);
        course memory _course = Course[_certificate.CourseId];
        student memory _student = Student[_certificate.StudentId];
        copyBytesNToBytes('{"Issuer":"', certSpec, pointer);
        copyBytesNToBytes(Institute, certSpec, pointer);
        copyBytesNToBytes('","CertificateId":"', certSpec, pointer);
        copyBytesNToBytes(_certificateId, certSpec, pointer);
        copyBytesNToBytes('","Name":"', certSpec, pointer);
        copyBytesNToBytes(_student.Name, certSpec, pointer);
        copyBytesNToBytes('","NationalId":"', certSpec, pointer);
        copyBytesNToBytes( _student.NationalId, certSpec, pointer);
        copyBytesNToBytes('","FatherName":"', certSpec, pointer);
        copyBytesNToBytes(_student.FatherName, certSpec, pointer);
        copyBytesNToBytes('","CourseId":"', certSpec, pointer);
        copyBytesNToBytes(_course.CourseNumber, certSpec, pointer);
        copyBytesNToBytes('","CourseName":"', certSpec, pointer);
        copyBytesToBytes(_course.CourseName, certSpec, pointer);
        copyBytesNToBytes('","StartDate":"', certSpec, pointer);
        copyBytesNToBytes(_course.StartDate, certSpec, pointer);
        copyBytesNToBytes('","EndDate":"', certSpec, pointer);
        copyBytesNToBytes(_course.EndDate, certSpec, pointer);
        copyBytesNToBytes('","DurationHours":"', certSpec, pointer);
        copyBytesNToBytes(uintToBytesN(_course.Hours), certSpec, pointer);
        copyBytesNToBytes('","Instructor":"', certSpec, pointer);
        copyBytesToBytes(Instructor[_course.InstructorId], certSpec, pointer);
        uint CertificateType = _certificate.CertificateType;
        bytes10 _certType;
        if (CertificateType == 1)
            _certType = 'Attendance';
        else if (CertificateType == 2)
            _certType = 'Online';
        else if (CertificateType == 3)
            _certType = 'Video';
        copyBytesNToBytes('","CourseType":"', certSpec, pointer);
        copyBytesNToBytes(_certType, certSpec, pointer);
        copyBytesNToBytes('","Result":"', certSpec, pointer);
        copyBytesNToBytes(_certificate.Result, certSpec, pointer);
        copyBytesNToBytes('"}', certSpec, pointer);
        return(string(certSpec));
    }
    function EnableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
        bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
        certificate memory _certificate = Certificate[_certificateId];
        require(_certificate.Result != '');
        require(! _certificate.Enabled);
        Certificate[_certificateId].Enabled = true;
        return(true);
    }
    function DisableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
        bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
        certificate memory _certificate = Certificate[_certificateId];
        require(_certificate.Result != '');
        require(_certificate.Enabled);
        Certificate[_certificateId].Enabled = false;
        return(true);
    }
    function copyBytesNToBytes(bytes32 source, bytes destination, uint[1] pointer) internal pure {
        for (uint i=0; i < 32; i++) {
            if (source[i] == 0)
                break;
            else {
                destination[pointer[0]]=source[i];
                pointer[0]++;
            }
        }
    }
    function copyBytesToBytes(bytes source, bytes destination, uint[1] pointer) internal pure {
        for (uint i=0; i < source.length; i++) {
            destination[pointer[0]]=source[i];
            pointer[0]++;
        }
    }
    function uintToBytesN(uint v) internal pure returns (bytes32 ret) {
        if (v == 0) {
            ret = '0';
        }
        else {
            while (v > 0) {
//                ret = bytes32(uint(ret) / (2 ** 8));
//                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                ret = bytes32(uint(ret) >> 8);
                ret |= bytes32(((v % 10) + 48) << (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }
    function stringToBytes32(string str) internal pure returns(bytes32) {
        bytes32 bStrN;
        assembly {
            bStrN := mload(add(str, 32))
        }
        return(bStrN);
    }
}
