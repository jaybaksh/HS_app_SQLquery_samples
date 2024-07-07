/*---- Begin - Members who are Targets ----*/
SELECT 
count(m.contactguid) as "Count",
'Members who are Targets' as Segment_Description,
'1' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Target'
/*---- End - Members who are Targets ----*/	

UNION ALL

/*---- Begin - Members who are Control ----*/
SELECT 
count(m.contactguid) as "Count",
'Members who are Control' as Segment_Description,
'2' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Control'
/*---- End - Members who are Controls ----*/	

UNION ALL

/*---- Begin - Members who are Targets and are opted in to Email ----*/
SELECT 
count(m.contactguid) as "Count",
'Members who are Targets, opted in to Email' as Segment_Description,
'3' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Target'
and m.subscriptions_EMAILOPTIN = 'True'
/*---- End - Members who are Targets and are opted in to Email ----*/

UNION ALL

/*---- Begin - UK Members who are Targets and are opted in to Email ----*/
SELECT 
count(m.contactguid) as "Count",
'UK Members, who are Targets, opted in to Email' as Segment_Description,
'4' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Target'
and m.subscriptions_EMAILOPTIN = 'True'
and m.countrycode = 'UK'
/*---- End - UK Members who are Targets and are opted in to Email ----*/

UNION ALL

/*---- Begin - Onboarding - UK Members, up to 35 days, who are between Deciles 1 and 7, Targets and opted in to Email. ----*/
SELECT 
count(m.contactguid) as "Count",
'Onboarding - UK Members, up to 35 days since the member joined, between Deciles 1 and 7, Targets and opted in to Email' as Segment_Description,
'5' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Target'
and m.subscriptions_EMAILOPTIN = 'True'
and m.countrycode = 'UK'
and p.deciles BETWEEN 1 AND 7
and DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) <= 35 
/*---- END - Onboarding - UK Members who are between Deciles 1 and 7, Targets and opted in to Email. ----*/

UNION ALL 

/*---- Begin - In-Life - UK Members who are between Deciles 1 and 7, Targets and opted in to Email. ----*/
SELECT 
count(m.contactguid) as "Count",
'In-life - UK Members, over 35 days since joining, who are between Deciles 1 and 7, Targets and opted in to Email' as Segment_Description,
'6' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Target'
and m.subscriptions_EMAILOPTIN = 'True'
and m.countrycode = 'UK'
and p.deciles BETWEEN 1 AND 7
and DATEDIFF(day, m.LATESTJOINDATE, GETDATE()) >= 36
/*---- END - At-Risk UK Members who are Deciles 8, 9 and 10, Targets and opted in to Email. ----*/


UNION ALL

/*---- Begin - At-Risk - UK Members who are Deciles 8, 9 and 10, Targets and opted in to Email. ----*/
SELECT 
count(m.contactguid) as "Count",
'At-Risk - UK Members, who are Deciles 8, 9 and 10, Targets and opted in to Email' as Segment_Description,
'7' as Index
FROM PRD_Members m
INNER JOIN PRD_Propensity p on m.contactguid = p.contactguid 
and p.ISCONTROLGROUP = 'Target'
and m.subscriptions_EMAILOPTIN = 'True'
and m.countrycode = 'UK'
and p.deciles IN(8,9,10)
/*---- END - At-Risk UK Members who are Deciles 8, 9 and 10, Targets and opted in to Email. ----*/


UNION ALL


/*---- Begin - Onboarding - Members who entered the Free PT Onboarding Journey ----*/
SELECT
      COUNT(s.SubscriberKey) as "Count",
      '' as Segment_Description
FROM _Job AS j
    LEFT JOIN _Sent AS s 
        ON j.JobID = s.JobID 
        AND j.TriggererSendDefinitionObjectID = s.TriggererSendDefinitionObjectID
    LEFT JOIN _JourneyActivity  AS ja 
        ON s.TriggererSendDefinitionObjectID = ja.JourneyActivityObjectID
    LEFT JOIN _Journey AS jy 
        ON ja.VersionID = jy.VersionID
WHERE
    s.EventDate > DATEADD(DD, -7, GETDATE())
    AND jy.JourneyID = 'ED734C77-89E0-4D53-BE22-3912DE3CCC03' 
    AND (j.EmailName LIKE 'Email 1a%' or j.EmailName LIKE 'Email 1b%')
/*---- End - Begin - Onboarding - Members who entered the Free PT Onboarding Journey  ----*/



SELECT
      COUNT(s.SubscriberKey) as "Count"
FROM _Job AS j
    LEFT JOIN _Sent AS s 
        ON j.JobID = s.JobID 
        AND j.TriggererSendDefinitionObjectID = s.TriggererSendDefinitionObjectID
    LEFT JOIN _JourneyActivity  AS ja 
        ON s.TriggererSendDefinitionObjectID = ja.JourneyActivityObjectID
    LEFT JOIN _Journey AS jy 
        ON ja.VersionID = jy.VersionID
WHERE
    s.EventDate > DATEADD(DD, -7, GETDATE())
    AND jy.JourneyID = '82F978B8-3A5A-47A2-8AAC-EFFC682B59C8'
    AND (j.EmailName LIKE 'Email 1a%' or j.EmailName LIKE 'Email 1b%' or j.EmailName LIKE 'Email 3%')





