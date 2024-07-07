/*
Removed Decile filtering 1 to 7 in this version as agreed with Maks on Feb 13

  Query that populates the Data Extension which is an entry source for the Journey 
  that enables us to send Onboarding Emails 1 and 2 - encouraging new Members to use their FREE signup PT session.
*/

SELECT
      m.CONTACTGUID as CONTACTGUID
    , m.NEWSIGNUPPTAVALIABLE as NEWSIGNUPPTAVALIABLE  
    , c.GENERALMANAGER as GENERALMANAGER
    , m.HeldPTCount as HeldPTCount
    , m.LASTPTSESSION as LASTPTSESSION
    , m.EMAILADDRESS as EMAILADDRESS
    , m.ISPENDINGSIGNUPPT as ISPENDINGSIGNUPPT
    , m.PENDINGSIGNUPPTCOUNT as PENDINGSIGNUPPTCOUNT
    , m.FIRSTNAME as FIRSTNAME
    , m.CLUBNAME as CLUBNAME
    , m.HOMECLUBID as HOMECLUBID
FROM PRD_Members m
LEFT JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
LEFT JOIN PRD_Propensity p ON m.CONTACTGUID = p.CONTACTGUID
LEFT JOIN PRD_Packages pk on m.PACKAGEID = pk.PACKAGEID
WHERE DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) = 11
    AND pk.Trial = 'False'
    AND m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.CURRENTSTATUS = 'Package OK'
    AND m.NEWSIGNUPPTAVALIABLE >= 1
    AND m.EMAILADDRESS <> 'noemail@davidlloyd.co.uk'
    AND p.ISCONTROLGROUP = 'Target'




/* 
  Query that populates the Data Extension which is an entry source for the Journey 
  that enables us to send Onboarding Email 3 - ecouraging new Members to purchase Paid PT sessions
  These Members have consumed all FREE PT sessions or their remaining FREE PT sessions have expired.
*/

SELECT
      m.CONTACTGUID as CONTACTGUID
    , m.NEWSIGNUPPTAVALIABLE as NEWSIGNUPPTAVALIABLE  
    , c.GENERALMANAGER as GENERALMANAGER
    , m.HeldPTCount as HeldPTCount
    , m.LASTPTSESSION as LASTPTSESSION
    , m.EMAILADDRESS as EMAILADDRESS
    , m.ISPENDINGSIGNUPPT as ISPENDINGSIGNUPPT
    , m.PENDINGSIGNUPPTCOUNT as PENDINGSIGNUPPTCOUNT
    , m.FIRSTNAME as FIRSTNAME
    , m.CLUBNAME as CLUBNAME
    , m.HOMECLUBID as HOMECLUBID
FROM PRD_Members m
INNER JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
INNER JOIN PRD_Propensity p on m.CONTACTGUID = p.CONTACTGUID
/*----This table contains everyone who has already been sent Onboarding Paid at least once----*/
LEFT JOIN PRD_Onboarding_Email3 o ON o.CONTACTGUID = m.CONTACTGUID
WHERE DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) BETWEEN 11 AND 25
    AND m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.CURRENTSTATUS = 'Package OK'
    AND m.LASTPAIDPTSESSIONDATE IS NULL
    AND p.ISCONTROLGROUP = 'Target'
    AND (o.CONTACTGUID IS NULL OR (o.CONTACTGUID IS NOT NULL AND o.JOURNEYEXITDATE < DATEADD(MM, -6, GETDATE())))
/*--A) Members who have completed 1 or more signup PT sessions, have no signup PT remaining and have no further signup PT booked in the future--*/
    AND (
        (m.HeldPTCount >= 1
        AND m.NEWSIGNUPPTAVALIABLE = 0
        AND (m.PENDINGSIGNUPPTCOUNT = 0 OR m.ISPENDINGSIGNUPPT = 'False')
        )
/*--B) Members who have completed 1 or more signup PT, still have signup PT remaining, but remaining signup PT are now expired--*/
    OR 
        (m.HeldPTCount >= 1
        AND m.NEWSIGNUPPTAVALIABLE > 0
        AND m.WELCOMINGPTEXPIRYDATE < GETDATE())
        )