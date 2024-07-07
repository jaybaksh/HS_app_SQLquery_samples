---- PWC_In-Life_GroupEx_MopUp
SELECT
	s.SubscriberKey as CONTACTGUID
	, il.GENERALMANAGER as GENERALMANAGER
	, il.EMAILADDRESS as EMAILADDRESS
	, il.ISPENDINGGROUPEX as ISPENDINGGROUPEX
	, il.FIRSTNAME as FIRSTNAME
	, il.CLUBNAME as CLUBNAME
	, il.ISCONTROLGROUP
	, il.DECILES
	, m.LASTGROUPEXDATE
, s.EventDate AT TIME ZONE 'Central America Standard Time' AT TIME ZONE 'UTC' AS JOURNEYEXITDATE,
'Email3' as JOURNEYSTATUS
FROM _Job AS j
LEFT JOIN _Sent AS s ON j.JobID = s.JobID AND j.TriggererSendDefinitionObjectID = s.TriggererSendDefinitionObjectID
INNER JOIN [In-Life_Archive_for_Reporting] il on s.SubscriberKey = il.contactguid
LEFT JOIN _JourneyActivity  AS ja ON s.TriggererSendDefinitionObjectID = ja.JourneyActivityObjectID
LEFT JOIN _Journey AS jy ON ja.VersionID = jy.VersionID
LEFT JOIN PRD_Members m on il.CONTACTGUID = m.CONTACTGUID
WHERE
jy.JourneyID = 'B42DE6A2-C6A5-47CF-8371-0F72AFC2F5E5'
AND j.EmailName LIKE 'In Life 3%'


---- Members still eligible for 1 or 2 more emails
select distinct il.contactguid, m.lastgroupexdate, m.ISPENDINGGROUPEX, il.journeystatus
from [In-Life_Archive_for_Reporting] il
left join prd_members m on il.contactguid = m.contactguid and m.lastgroupexdate is null and m.ISPENDINGGROUPEX = 'False'
where (il.journeystatus = 'Email1' or il.journeystatus = 'Email2')



















---- New query
/* 
1)Not attended GEX by day 35 of membership, email sent at day 35. Can re-enter the journey after 6 months if GEX class not booked in last 3 months

2) Regardless of tenure – send to members who haven’t attended a GEX class for 3 consecutive months, but can’t re-enter for 6 months.*/
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
    	)














