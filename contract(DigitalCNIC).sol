pragma solidity ^0.4.11;
// We have to specify what version of compiler this code will compile with

contract DigitalCNIC{
    
    string  firstname="";                               //first name of citizen
    string  lastname="";                               //Last name of citizen
    uint256  FromDate=block.timestamp;                //Date of block creation
    uint256  CNICnum=block.number;                   //Unique block Number
    uint16 constant ORIGIN_YEAR = 1970;
    uint constant YEAR_IN_SECONDS = 31536000;       //total seconds in a year
    uint constant LEAP_YEAR_IN_SECONDS = 31622400;  //total seconds in a Leap year
    uint constant DAY_IN_SECONDS = 86400;           //total seconds in a Day
    string year=" ";                                //Applied year             
    string monthh=" ";                             //Applied month
    string issuedDate=" ";                         //CNIC issued date
    uint tempyear;                                
    string Endyear=" ";                           //Ending year
    string EndingDate=" ";                        //CNIC expiry date
    
      
   struct DateTime                               //to convert timestamp into human understandable Date
   {
    uint16 year;
    uint8 month;
    uint8 day;
    uint8 hour;
    uint8 minute;
    uint8 second;
    uint8 weekday;
   }
      
  //to convert Integer into String  
 
 function uintToString(uint v) private constant returns (string str) 
  {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) 
        {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) 
        {
            s[j] = reversed[i - j];
        }
        str = string(s);
  }
  
  //to convert timestamp into human understandable Date
  
function getDaysInMonth(uint8 month, uint16 year) private constant returns (uint8) 
  {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) 
                {
                     return 31;
                }
        else if (month == 4 || month == 6 || month == 9 || month == 11) 
                {
                        return 30;
                }
        else if (isLeapYear(year))
                {
                        return 29;
                }
        else 
                {
                        return 28;
                }
  }
  
  //to convert timestamp into human understandable Date
  
function getHour(uint timestamp) private constant returns (uint8)
   {
      return uint8((timestamp / 60 / 60) % 24);
   }
        
   
 //to convert timestamp into human understandable Date

  function getMinute(uint timestamp)private constant returns (uint8)
   {
                return uint8((timestamp / 60) % 60);
   }
 
 //to convert timestamp into human understandable Date

  function getSecond(uint timestamp)private constant returns (uint8)
   {
                return uint8(timestamp % 60);
   }

 //to convert timestamp into human understandable Date 
  
function getWeekday(uint timestamp)private constant returns (uint8) 
   {
                return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
   }

 //to convert timestamp into human understandable Date

  function parseTimestamp(uint timestamp) internal returns (DateTime dt) 
   {
                uint secondsAccountedFor = 0;
                uint buf;
                uint8 i;

                dt.year = getYear(timestamp);
                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

                // Month
                uint secondsInMonth;
                for (i = 1; i <= 12; i++) 
                        {
                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                         if (secondsInMonth + secondsAccountedFor > timestamp) 
                         {
                                dt.month = i;
                                break;
                         }
                         secondsAccountedFor += secondsInMonth;
                        }

                // Day
                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) 
                       {
                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i;
                                break;
                       }
                        secondsAccountedFor += DAY_IN_SECONDS;
                      }

                // Hour
                dt.hour = getHour(timestamp);

                // Minute
                dt.minute = getMinute(timestamp);

                // Second
                dt.second = getSecond(timestamp);

                // Day of week.
                dt.weekday = getWeekday(timestamp);
  }
  

 //to convert timestamp into human understandable Date

  function leapYearsBefore(uint year)private constant returns (uint) 
        {
                year -= 1;
                return year / 4 - year / 100 + year / 400;
        }
  

 //to convert timestamp into human understandable Date      

  function  isLeapYear(uint16 year)private constant returns (bool)
    {
                if (year % 4 != 0) 
                {
                        return false;
                }
                if (year % 100 != 0) 
                {
                        return true;
                }
                if (year % 400 != 0)
                {
                        return false;
                }
                return true;
   }
 

//to convert timestamp into human understandable Date   

 function getYear(uint timestamp)private constant returns (uint16)
 {
               
                uint secondsAccountedFor = 0;
                uint16 year;
                uint numLeapYears;

                // Year
                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

                while (secondsAccountedFor > timestamp) {
                        if (isLeapYear(uint16(year - 1))) {
                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                secondsAccountedFor -= YEAR_IN_SECONDS;
                        }
                        year -= 1;
                }
            
                return year;
  }
    

 //To concatenate year & month
 
function strConcat(string _a, string _b) internal returns (string)
{
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
 
    string memory abcde = new string(_ba.length + _bb.length);
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
  
    return string(babcde);
}

 //This function will give CNIC Issued date 

function CNICissuedDate() constant returns(string)
{
           year=uintToString(getYear(FromDate));
          //uint16 year=uint8(getYear(FromDate));
          monthh= uintToString(parseTimestamp(FromDate).month);
          issuedDate = strConcat(year ,monthh);
          return issuedDate;
}
   
 
 //This function will give CNIC Ending date 

function CNICendingDate() constant returns(string)
{
          tempyear=getYear(FromDate);
          tempyear+=10;
          monthh= uintToString(parseTimestamp(FromDate).month);
          Endyear=uintToString(tempyear);
          EndingDate=strConcat(Endyear,monthh);
          return EndingDate;
}

     
      
 //This function will return cnic unique number
 
 function CNICnumber() constant returns(uint256)
    {
        return CNICnum;
    }
    
    
 //This function will prompt User's first name
    
function Firstname(string fname) returns(string)
    {
        firstname=fname;
        return firstname ;
        
    }
  

 //This function will prompt User's last name 
    
 function Lastname(string lname) returns(string)
    {
        lastname=lname;
        return lname;
    }
}