pragma solidity ^0.5.1;
import './DataRegister.sol';
contract CryptoClassCertificate is DataRegister {
    constructor(string memory _Institute) public notEmpty(_Institute) {
        owner = msg.sender;
        Institute = stringToBytes32(_Institute);
    }
    function GetInstitute() public view returns(string  memory) {
        uint[1] memory pointer;
        pointer[0]=0;
        bytes memory institute=new bytes(48);
        copyBytesToBytes('{"Institute":"', institute, pointer);
        copyBytesNToBytes(Institute, institute, pointer);
        copyBytesToBytes('"}', institute, pointer);
        return(string(institute));
    }
    function GetInstructors() public view onlyOwner returns(string memory) {
        uint len = 40;
        uint i;
        for (i=1 ; i <= InstructorCount ; i++) 
            len += 40 + Instructor[InstructorUIds[i]].length;
        bytes memory instructors = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{ "Instructors":[', instructors, pointer);
        for (i=1 ; i <= InstructorCount ; i++) {
            if (i > 1) 
                copyBytesNToBytes(',', instructors, pointer);
            copyBytesNToBytes('{"NationalId":"', instructors, pointer);
            copyBytesNToBytes(InstructorUIds[i], instructors, pointer);
            copyBytesNToBytes('","Name":"', instructors, pointer);
            copyBytesToBytes(Instructor[InstructorUIds[i]], instructors, pointer);
            copyBytesNToBytes('"}', instructors, pointer);
        }
        copyBytesNToBytes(']}', instructors, pointer);
        return(string(instructors));
    }
    function GetInstructor(string memory InstructorNationalId) public view notEmpty(InstructorNationalId) returns(string memory) {
        bytes10 _instructorUId = bytes10(stringToBytes32(InstructorNationalId));
        require(Instructor[_instructorUId].length > 0);
        uint len = 70;
        len += Instructor[_instructorUId].length;
        bytes memory _instructor = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{ "Instructor":{"NationalId":"', _instructor, pointer);
        copyBytesNToBytes(_instructorUId, _instructor, pointer);
        copyBytesNToBytes('","Name":"', _instructor, pointer);
        copyBytesToBytes(Instructor[_instructorUId], _instructor, pointer);
        copyBytesNToBytes('"}}', _instructor, pointer);
        return(string(_instructor));
    }
    function GetInstructorCourses(string memory InstructorNationalId) public view notEmpty(InstructorNationalId) returns(string memory) {
        bytes10 _instructorNationalId = bytes10(stringToBytes32(InstructorNationalId));
        require(Instructor[_instructorNationalId].length > 0);
        uint _instructorId = 0;
        uint i;
        for (i = 1; i <= InstructorCount; i++)
            if (InstructorUIds[i] == _instructorNationalId) {
                _instructorId = i;
                break;
            }
        uint len = 30;
        course memory _course;
        for (i=0; i< CourseInstructor.length; i++) {
            if (CourseInstructor[i].InstructorId == _instructorId) { 
                _course = Course[CourseUIds[CourseInstructor[i].CourseId]];
                len += 180 + Institute.length + _course.CourseName.length + Instructor[InstructorUIds[_instructorId]].length;
            }
        }
        bytes memory courseInfo = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{"Courses":[', courseInfo, pointer);
        bool first = true;
        for (i=0; i< CourseInstructor.length; i++) {
            if (CourseInstructor[i].InstructorId == _instructorId) { 
                _course = Course[CourseUIds[CourseInstructor[i].CourseId]];
                if (first)
                    first = false;
                else
                    copyBytesNToBytes(',', courseInfo, pointer);
                copyBytesNToBytes('{"CourseId":"', courseInfo, pointer);
                copyBytesNToBytes(CourseUIds[CourseInstructor[i].CourseId], courseInfo, pointer);
                copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
                copyBytesToBytes(_course.CourseName, courseInfo, pointer);
                copyBytesNToBytes('","StartDate":"', courseInfo, pointer);
                copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
                copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
                copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
                copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
                copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
                copyBytesNToBytes('"}', courseInfo, pointer);
            }
        }
        copyBytesNToBytes(']}', courseInfo, pointer);
        return(string(courseInfo));
    }
    function CourseIdByUId(bytes10 CourseUId) private view returns(uint CourseId) {
        CourseId = 0;
        for (uint i=1; i<=CourseCount;i++)
            if (CourseUIds[i] == CourseUId) {
                CourseId = i;
                break;
            }
        require(CourseId > 0);
    }
    function GetCourseInfo(string memory CourseUId) public view notEmpty(CourseUId) returns(string memory) {
        bytes10 _courseUId=bytes10(stringToBytes32(CourseUId));
        course memory _course;
        _course = Course[_courseUId];
        require(_course.CourseName.length > 0);
        uint _courseId=CourseIdByUId(_courseUId);
        uint i;
        uint len = 110;
        uint courseInstructorCount = 0;
        for (i=0; i< CourseInstructor.length; i++)
            if (CourseInstructor[i].CourseId == _courseId)
                courseInstructorCount++;
        uint[] memory courseInstructors = new uint[](courseInstructorCount); 
        courseInstructorCount = 0;
        for (i=0; i< CourseInstructor.length; i++)
            if (CourseInstructor[i].CourseId == _courseId) {
                courseInstructors[courseInstructorCount] = CourseInstructor[i].InstructorId;
                courseInstructorCount++;
                len += Instructor[InstructorUIds[CourseInstructor[i].InstructorId]].length + 5;
            }
        len += Institute.length + 10 + _course.CourseName.length + 10 + 10;
        bytes memory courseInfo = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{"Course":', courseInfo, pointer);
        copyBytesNToBytes('{"Issuer":"', courseInfo, pointer);
        copyBytesNToBytes(Institute, courseInfo, pointer);
        copyBytesNToBytes('","CourseUId":"', courseInfo, pointer);
        copyBytesNToBytes(_courseUId, courseInfo, pointer);
        copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
        copyBytesToBytes(_course.CourseName, courseInfo, pointer);
        if (courseInstructorCount == 1) {
            copyBytesNToBytes('","Instructor":"', courseInfo, pointer);
            copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[0]]], courseInfo, pointer);
            copyBytesNToBytes('"', courseInfo, pointer);
        }
        else {
            copyBytesNToBytes('","Instructors":[', courseInfo, pointer);
            for (i=0; i<courseInstructorCount; i++){
                if (i > 0)
                    copyBytesNToBytes(',', courseInfo, pointer);
                copyBytesNToBytes('"', courseInfo, pointer);
                copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[i]]], courseInfo, pointer);
                copyBytesNToBytes('"', courseInfo, pointer);
            }
            copyBytesNToBytes(']', courseInfo, pointer);
        }
        copyBytesNToBytes(',"StartDate":"', courseInfo, pointer);
        copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
        copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
        copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
        copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
        copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
        copyBytesNToBytes('"}}', courseInfo, pointer);
        return(string(courseInfo));
    }
    function GetCourses() public view returns(string memory) {
        uint len = 30;
        uint i;
        course memory _course;
        for (i=1 ; i <= CourseCount ; i++) {
            _course = Course[CourseUIds[i]];
            len += 90 + 10 + _course.CourseName.length + 10 + 12 + 12 + 6;
        }
        bytes memory courses = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        bytes32 hrs;
        copyBytesNToBytes('{"Courses":[', courses, pointer);
        for (i=1 ; i <= CourseCount ; i++) {
            if (i > 1)
                copyBytesNToBytes(',', courses, pointer);
            _course = Course[CourseUIds[i]];
            copyBytesNToBytes('{"UId":"', courses, pointer);
            copyBytesNToBytes(CourseUIds[i], courses, pointer);
            copyBytesNToBytes('","Name":"', courses, pointer);
            copyBytesToBytes(_course.CourseName, courses, pointer);
            copyBytesNToBytes('","StartDate":"', courses, pointer);
            copyBytesNToBytes(_course.StartDate, courses, pointer);
            copyBytesNToBytes('","EndDate":"', courses, pointer);
            copyBytesNToBytes(_course.EndDate, courses, pointer);
            copyBytesNToBytes('","Duration":"', courses, pointer);
            hrs = uintToBytesN(_course.Hours);
            copyBytesNToBytes(hrs, courses, pointer);
            copyBytesNToBytes(' Hours"}', courses, pointer);
        }
        copyBytesNToBytes(']}', courses, pointer);
        return(string(courses));
    }
    function GetStudentInfo(string memory NationalId) public view notEmpty(NationalId) returns(string memory) {
        bytes10 _nationalId=bytes10(stringToBytes32(NationalId));
        bytes memory _student = Student[_nationalId];
        require(_student.length > 0);
        uint len = 110;
        len += Institute.length + 10 + _student.length + 10 ;
        bytes memory studentInfo = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{"Student":', studentInfo, pointer);
        copyBytesNToBytes('{"Issuer":"', studentInfo, pointer);
        copyBytesNToBytes(Institute, studentInfo, pointer);
        copyBytesNToBytes('","NationalId":"', studentInfo, pointer);
        copyBytesNToBytes(_nationalId, studentInfo, pointer);
        copyBytesNToBytes('","Name":"', studentInfo, pointer);
        copyBytesToBytes(_student, studentInfo, pointer);
        copyBytesNToBytes('"}}', studentInfo, pointer);
        return(string(studentInfo));
    }
    function GetStudents() public view onlyOwner returns(string memory) {
        uint len = 30;
        uint i;
        for (i=1 ; i <= StudentCount ; i++) 
            len += 50 + 3 + Student[StudentUIds[i]].length;
        bytes memory students = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{"Students":[', students, pointer);
        for (i=1 ; i <= StudentCount ; i++) {
            if (i > 1)
                copyBytesNToBytes(',', students, pointer);
            bytes memory _student = Student[StudentUIds[i]];
            copyBytesNToBytes('{"NationalId":"', students, pointer);
            copyBytesNToBytes(StudentUIds[i], students, pointer);
            copyBytesNToBytes('","Name":"', students, pointer);
            copyBytesToBytes(_student, students, pointer);
            copyBytesNToBytes('"}', students, pointer);
        }
        copyBytesNToBytes(']}', students, pointer);
        return(string(students));
    }
    function GetCertificates() public view onlyOwner returns(string memory) {
        uint len = 30;
        uint i;
        len += CertificateCount * 40;
        bytes memory certificates = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{"Certificates":[', certificates, pointer);
        for (i = 1 ; i <= CertificateCount ; i++) {
            if (i > 1)
                copyBytesNToBytes(',', certificates, pointer);
            copyBytesNToBytes('{"CertificateId":"', certificates, pointer);
            copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
            copyBytesNToBytes('"}', certificates, pointer);
        }
        copyBytesNToBytes(']}', certificates, pointer);
        return(string(certificates));
    }
    function GetStudentCertificates(string memory NationalId) public view notEmpty(NationalId) returns(string memory) {
        uint len = 30;
        uint i;
        bytes10 _nationalId=bytes10(stringToBytes32(NationalId));
        for (i = 1 ; i <= CertificateCount ; i++) {
            if (StudentUIds[i] == _nationalId) {
                len += 50 + Course[CourseUIds[Certificate[CertificateUIds[i]].CourseId]].CourseName.length;
            }
        }
        bytes memory certificates = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        copyBytesNToBytes('{"Certificates":[', certificates, pointer);
        bool first=true;
        for (i = 1 ; i <= CertificateCount ; i++) {
            if (StudentUIds[i] == _nationalId) {
                if (first)
                    first = false;
                else
                    copyBytesNToBytes(',', certificates, pointer);
                copyBytesNToBytes('{"CertificateId":"', certificates, pointer);
                copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
                copyBytesNToBytes('","CourseName":"', certificates, pointer);
                copyBytesToBytes(Course[CourseUIds[Certificate[CertificateUIds[i]].CourseId]].CourseName, certificates, pointer);
                copyBytesNToBytes('"}', certificates, pointer);
            }
        }
        copyBytesNToBytes(']}', certificates, pointer);
        return(string(certificates));
    }
    function GetCertificate(string memory CertificateId) public view notEmpty(CertificateId) returns(string memory) {
        bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
        certificate memory _certificate = Certificate[_certificateId];
        course memory _course = Course[CourseUIds[_certificate.CourseId]];
        bytes memory _student = Student[StudentUIds[_certificate.StudentId]];
        bytes memory certSpec;
        uint len = 500;
        uint i;
        uint courseInstructorCount = 0;
        for (i=0; i< CourseInstructor.length; i++)
            if (CourseInstructor[i].CourseId == _certificate.CourseId)
                courseInstructorCount++;
        uint[] memory courseInstructors = new uint[](courseInstructorCount); 
        courseInstructorCount = 0;
        for (i=0; i< CourseInstructor.length; i++)
            if (CourseInstructor[i].CourseId == _certificate.CourseId) {
                courseInstructors[courseInstructorCount] = CourseInstructor[i].InstructorId;
                courseInstructorCount++;
                len += Instructor[InstructorUIds[CourseInstructor[i].InstructorId]].length + 5;
            }
        uint[1] memory pointer;
        pointer[0] = 0;
        len += _course.CourseName.length;
        certSpec = new bytes(len);
        require(_certificate.StudentId > 0);
        require(_certificate.Enabled);
        copyBytesNToBytes('{"Certificate":{"Issuer":"', certSpec, pointer);
        copyBytesNToBytes(Institute, certSpec, pointer);
        copyBytesNToBytes('","CertificateId":"', certSpec, pointer);
        copyBytesNToBytes(_certificateId, certSpec, pointer);
        copyBytesNToBytes('","Name":"', certSpec, pointer);
        copyBytesToBytes(_student, certSpec, pointer);
        copyBytesNToBytes('","NationalId":"', certSpec, pointer);
        copyBytesNToBytes( StudentUIds[_certificate.StudentId], certSpec, pointer);
        copyBytesNToBytes('","CourseId":"', certSpec, pointer);
        copyBytesNToBytes(CourseUIds[_certificate.CourseId], certSpec, pointer);
        copyBytesNToBytes('","CourseName":"', certSpec, pointer);
        copyBytesToBytes(_course.CourseName, certSpec, pointer);
        copyBytesNToBytes('","StartDate":"', certSpec, pointer);
        copyBytesNToBytes(_course.StartDate, certSpec, pointer);
        copyBytesNToBytes('","EndDate":"', certSpec, pointer);
        copyBytesNToBytes(_course.EndDate, certSpec, pointer);
        copyBytesNToBytes('","DurationHours":"', certSpec, pointer);
        copyBytesNToBytes(uintToBytesN(_course.Hours), certSpec, pointer);
        if (courseInstructorCount == 1) {
            copyBytesNToBytes('","Instructor":"', certSpec, pointer);
            copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[0]]], certSpec, pointer);
            copyBytesNToBytes('"', certSpec, pointer);
        }
        else {
            copyBytesNToBytes('","Instructors":[', certSpec, pointer);
            for (i=0; i<courseInstructorCount; i++){
                if (i > 0)
                    copyBytesNToBytes(',', certSpec, pointer);
                copyBytesNToBytes('"', certSpec, pointer);
                copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[i]]], certSpec, pointer);
                copyBytesNToBytes('"', certSpec, pointer);
            }
            copyBytesNToBytes(']', certSpec, pointer);
        }
        bytes10 _certType = GetCertificateTypeDescription(_certificate.CertificateType);
        copyBytesNToBytes(',"CourseType":"', certSpec, pointer);
        copyBytesNToBytes(_certType, certSpec, pointer);
        copyBytesNToBytes('","Result":"', certSpec, pointer);
        copyBytesNToBytes(_certificate.Result, certSpec, pointer);
        copyBytesNToBytes('"}}', certSpec, pointer);
        return(string(certSpec));
    }
    function GetCertificateTypeDescription(uint Type) pure internal returns(bytes10) {
        if (Type == 1) 
            return('Attendance');
        else if (Type == 2)
            return('Online');
        else if (Type == 3)
            return('Video');
        else if (Type == 4)
            return('ELearning');
        else
            return(bytes10(uintToBytesN(Type)));
    } 
}
