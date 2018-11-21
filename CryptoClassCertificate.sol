pragma solidity ^0.4.25;
import './DataRegister.sol';
contract CryptoClassCertificate is DataRegister {
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
    function GetInstructor(string InstructorId) public view notEmpty(InstructorId) returns(string) {
        bytes10 _instructorId = bytes10(stringToBytes32(InstructorId));
        return(string(Instructor[InstructorIds[_instructorId]]));
    }
    function GetInstructorCourses(string InstructorId) public view notEmpty(InstructorId) returns(string) {
        bytes10 _instructorId = bytes10(stringToBytes32(InstructorId));
        uint _instructorNumber = InstructorIds[_instructorId];
        bool found = false;
        uint len = 0;
        for (uint i=1; i<=CourseCount; i++) {
            if (Course[i].InstructorId == _instructorNumber) 
                len += 100 + Institute.length + 10 + Course[i].CourseName.length + 10 + 10 + Instructor[Course[i].InstructorId].length;
        }
        bytes memory courseInfo = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        for (i=1; i<=CourseCount; i++) {
            if (Course[i].InstructorId == _instructorNumber) {
                found = true;
                copyBytesNToBytes('\nCourse Id: ', courseInfo, pointer);
                copyBytesNToBytes(Course[i].CourseNumber, courseInfo, pointer);
                copyBytesNToBytes('\nCourse Name: ', courseInfo, pointer);
                copyBytesToBytes(Course[i].CourseName, courseInfo, pointer);
                copyBytesNToBytes('\nStart date: ', courseInfo, pointer);
                copyBytesNToBytes( Course[i].StartDate, courseInfo, pointer);
                copyBytesNToBytes("\nEnd date: ", courseInfo, pointer);
                copyBytesNToBytes( Course[i].EndDate, courseInfo, pointer);
                copyBytesNToBytes("\nDuration: ", courseInfo, pointer);
                copyBytesNToBytes( uintToBytesN(Course[i].Hours), courseInfo, pointer);
                copyBytesNToBytes(" Hours\n", courseInfo, pointer);
            }
        }
        require(found);
        return(string(courseInfo));
    }
    function GetJsonInstructorCourses(string InstructorId) public view notEmpty(InstructorId) returns(string) {
        bytes10 _instructorId = bytes10(stringToBytes32(InstructorId));
        uint _instructorNumber = InstructorIds[_instructorId];
        bool found = false;
        uint len = 0;
        for (uint i=1; i<=CourseCount; i++) {
            if (Course[i].InstructorId == _instructorNumber) 
                len += 100 + Institute.length + 10 + Course[i].CourseName.length + 10 + 10 + Instructor[Course[i].InstructorId].length;
        }
        bytes memory courseInfo = new bytes(len);
        uint[1] memory pointer;
        pointer[0]=0;
        bool first = true;
        for (i=1; i<=CourseCount; i++) {
            if (Course[i].InstructorId == _instructorNumber) {
                if (first)
                    first = false;
                else
                    copyBytesNToBytes(',', courseInfo, pointer);
                found = true;
                copyBytesNToBytes('[CourseId":"', courseInfo, pointer);
                copyBytesNToBytes(Course[i].CourseNumber, courseInfo, pointer);
                copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
                copyBytesToBytes(Course[i].CourseName, courseInfo, pointer);
                copyBytesNToBytes('","StartDate":"', courseInfo, pointer);
                copyBytesNToBytes( Course[i].StartDate, courseInfo, pointer);
                copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
                copyBytesNToBytes( Course[i].EndDate, courseInfo, pointer);
                copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
                copyBytesNToBytes( uintToBytesN(Course[i].Hours), courseInfo, pointer);
                copyBytesNToBytes('"]', courseInfo, pointer);
            }
        }
        require(found);
        return(string(courseInfo));
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
        }
        require(found);
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
        }
        require(found);
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
        bytes10 _certType = GetCertificateTypeDescription(_certificate.CertificateType);
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
        bytes10 _certType = GetCertificateTypeDescription(_certificate.CertificateType);
        copyBytesNToBytes('","CourseType":"', certSpec, pointer);
        copyBytesNToBytes(_certType, certSpec, pointer);
        copyBytesNToBytes('","Result":"', certSpec, pointer);
        copyBytesNToBytes(_certificate.Result, certSpec, pointer);
        copyBytesNToBytes('"}', certSpec, pointer);
        return(string(certSpec));
    }
    function GetCertificateTypeDescription(uint Type) pure internal returns(bytes10) {
        if (Type == 1) 
            return('Attendance');
        if (Type == 2)
            return('Online');
        if (Type == 3)
            return('Video');
    } 
}
