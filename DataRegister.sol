pragma solidity ^0.4.25;
import './Operations.sol';
contract DataRegister is Operations {
    bytes32 Institute; 
    address owner;
    mapping(uint => bytes) Instructor;
    mapping(bytes10 => uint) InstructorIds;
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
    function RegisterInstructor(
        string instructorId, 
        string instructor
        ) public onlyOwner notEmpty(instructorId) notEmpty(instructor) {
            InstructorCount++;
            Instructor[InstructorCount] = bytes(instructor);
            InstructorIds[bytes10(stringToBytes32(instructorId))]=InstructorCount;
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
}
