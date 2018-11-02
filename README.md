# Certificate

This project is used for getting educational or training certificates from Ethereum smart contracts with a web-based interface for data entry and getting certificates.

## Getting Started

First of all I deployed the smart contract and debugged it. Now I am working on its web interface.

### Prerequisites

For installing this smart contract on Ethereum blockchain you need:

* Firefox or Chrome browser
* [Metamask](https://metamask.io/) pluggin for Firefox or Chrome
* [Remix](https://remix.ethereum.org) development web site for Solidity.  

### Installing

I suggest you to install the contract on Renkeby test net to see how you can initialize it and define certificates.

In this case you must have some Ether for Rinkeby test net. so you can go to [Faucet](https://faucet.rinkeby.io/) site and
do its step by step recommendations.

* Open Metamask pluggin, define your account and set its network to Rinkeby text network.
* Go to [Faucet](https://faucet.rinkeby.io/) web site and get some test Ether for your Metamask account.
* Open [Remix](https://remix.ethereum.org) on your browser.
* Go to Run tab on Remix, then set Environment to: Injected Web3.
* Now you see 'Certificate' on combobox, Write your institute name below in front of 'Deply' button and press Deploy
* Now your contract is deployed on Rinkeby test network.

## Running the tests

To test the certificate you must do this operations respectively:

* First you must define an instructor for your courses. Write an instructor name in front of 'RegisterInstructor' 
button inside "" signs, then press the button.

* Now you must define a course in front of 'RegisterCourse' button with Course Number (a string that contains an id for your course, 
e.g. "BT958428"), Course Name, Start Date, End Date, Duration (in hours) 
and Instructor Id. (Id of the first instructor is 1, the second one is 2 and so on) Then press the button.

* Then you must define at least one student with his (her) National Id, Name (first and last name) and Father's name.

* Finally you must define a certificate with Certificate Id (a string represents the id for the certificate, e.g. "98RS1781"), 
Course Id (1, 2, 3, ...), Student Id (1, 2, 3, ...), Certification Type (1 for attendance, 2 for online, 3 for video. You can 
change these settings in GetCertificateTypeDescription function depending on your institute needs.) and Result (a string like 
"Fine", "Good" and so on)

* Now You can Use functions 'GetCertificate' and 'GetJsonCertificate' having a certification id as a student or anyone else, 
functions 'GetCourseInfo' and 'GetJsonCourseInfo' having a course number, 'GetInstitute'  as  anyone, 
and functions 'GetInstructors', 'GetCorses', 'GetStudents', 'GetCertificates' as contract owner.

## Deployment

After you test and see the results, you can deply the Certificate smart contract on Ethereum main network.
so you can set Metamask network to 'Main Ethereum Network'.

## Author

* **Alireza Zojaji** - *Founder of CryptoClass Center* - [CryptoClass](https://CryptoClass.center)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

