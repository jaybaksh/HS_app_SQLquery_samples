SELECT
      m.CONTACTGUID as CONTACTGUID
    , m.EMAILADDRESS as EMAILADDRESS
    , m.ISPENDINGGROUPEX as ISPENDINGGROUPEX
    , m.LASTGROUPEXDATE
    , m.FIRSTNAME as FIRSTNAME
    , m.CLUBNAME as CLUBNAME
    , m.LATESTJOINDATE
    , c.GENERALMANAGER as GENERALMANAGER
    , p.ISCONTROLGROUP
    , p.DECILES
    , gx.JOURNEYEXITDATE
    , CASE 
    	WHEN DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) = 35 AND m.LASTGROUPEXDATE IS NULL THEN '35 Days Since Join Date, Not Booked GroupEx'
    	WHEN DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) > 35 AND m.LASTGROUPEXDATE < DATEADD(MM, -3, GETDATE()) THEN 'Over 35 Days Since Join Date, Not Booked GroupEx in 3 Months'
    	WHEN DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) > 35 AND m.LASTGROUPEXDATE IS NULL THEN 'Over 35 Days Since Join Date, Never Booked GroupEx'
      END as MEMBERDESCRIPTION
FROM PRD_Members m
INNER JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
INNER JOIN PRD_Propensity p on m.CONTACTGUID = p.CONTACTGUID
INNER JOIN PRD_Packages pk on m.PACKAGEID = pk.PACKAGEID
/*---- This table contains everyone who has already been sent In-Life GroupEx at least once ----*/
LEFT JOIN [PRD_In-Life_GroupEx] gx on m.CONTACTGUID = gx.CONTACTGUID
WHERE
    m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.CURRENTSTATUS = 'Package OK'
    AND p.ISCONTROLGROUP = 'Target'
    AND (p.DECILES BETWEEN 1 AND 7) 
    AND pk.Trial = 'False'
    AND m.ISPENDINGGROUPEX = 'FALSE'
    /*---- ClubId 132 - the Biscestor club is pending GroupEx class information from Dan and Chris. Exclusion to be removed once class comms provided ----*/
    AND c.CLUBID <> '132'
    AND m.emailaddress <> 'noemail@davidlloyd.co.uk'
	/*---- Never entered GroupEx journey before OR Entered over 6 Months ago ----*/
    AND (gx.CONTACTGUID IS NULL OR (gx.CONTACTGUID IS NOT NULL AND gx.JOURNEYEXITDATE < DATEADD(MM, -6, GETDATE())))
    AND (
    	/*---- 35 Days Since Join Date, Not Booked GroupEx ----*/
    	(DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) = 35 AND m.LASTGROUPEXDATE IS NULL) 
    	OR 
    	/*---- Over 35 Days Since Join Date, Not Booked GroupEx in 3 Months ----*/
    	(DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) > 35 AND m.LASTGROUPEXDATE IS NOT NULL AND m.LASTGROUPEXDATE < DATEADD(MM, -3, GETDATE()))
    	OR
    	/*---- Over 35 Days Since Join Date, Never Booked GroupEx ----*/
    	(DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) > 35 AND m.LASTGROUPEXDATE IS NULL)