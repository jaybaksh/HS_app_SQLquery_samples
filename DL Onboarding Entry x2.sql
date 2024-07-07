---- FREE Onboarding - OLD query
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
JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
WHERE DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) = 11
    AND m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.CURRENTSTATUS = 'Package OK'
/*-- All members entering Onboarding Email 1 and 2 must have 3 free signup PT sessions --*/
    AND m.NEWSIGNUPPTAVALIABLE <= 3







---- FREE Onboarding - NEW query
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

    AND m.NEWSIGNUPPTAVALIABLE BETWEEN 1 AND 3
    AND m.EMAILADDRESS <> 'noemail@davidlloyd.co.uk'
    AND p.ISCONTROLGROUP = 'Target'
    AND p.DECILES BETWEEN 1 AND 7




---- PAID Onboarding - OLD Query
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
JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
WHERE DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) >= 11
    AND DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) <= 25
    AND m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.CURRENTSTATUS = 'Package OK'
    AND m.LASTPAIDPTSESSIONDATE IS NULL
/*-- A) Members who heve completed 3 signup PT sessions and have not book any paid PT session in the past --*/    
    AND (
        (m.NEWSIGNUPPTAVALIABLE = 0
        AND m.HeldPTCount = 3
        AND m.PENDINGSIGNUPPTCOUNT = 0
/*--    AND filed looking for paid pt sessions booked for the future --*/
        )
/*-- B) Member who have 1 or 2 expired signup PT sessions and have not book any paid PT session in the past --*/        
    OR 
        (m.WELCOMINGPTEXPIRYDATE < GETDATE()
        AND m.HeldPTCount IN ('1', '2'))
        )







---- PAID Onboarding - New Query
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
JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
LEFT JOIN PRD_Propensity p on m.CONTACTGUID = p.CONTACTGUID
WHERE DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) >= 11
    AND DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) <= 25
    AND m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.CURRENTSTATUS = 'Package OK'
    AND m.LASTPAIDPTSESSIONDATE IS NULL
    AND p.ISCONTROLGROUP = 'Target'
    AND p.DECILES BETWEEN 1 AND 7
/*-- A) Members who heve completed 3 signup PT sessions and have not book any paid PT session in the past --*/    
    AND (
        (m.NEWSIGNUPPTAVALIABLE = 0
        AND m.HeldPTCount BETWEEN 1 AND 3
        AND m.PENDINGSIGNUPPTCOUNT = 0
/*--    AND filed looking for paid pt sessions booked for the future --*/
        )
/*-- B) Member who have 1 or 2 expired signup PT sessions and have not book any paid PT session in the past --*/        
    OR 
        (m.WELCOMINGPTEXPIRYDATE < GETDATE()
        AND m.HeldPTCount IN ('1', '2'))
        )




