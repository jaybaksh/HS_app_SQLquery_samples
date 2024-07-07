/*---- Begin - Onboarding - Members who entered the Free PT Onboarding Journey in yesterday----*/
SELECT
      s.SubscriberKey as CONTACTGUID,
      s.EventDate AT TIME ZONE 'Central America Standard Time' AT TIME ZONE 'UTC' AS date_entered
FROM _Job AS j
    LEFT JOIN _Sent AS s 
        ON j.JobID = s.JobID 
        AND j.TriggererSendDefinitionObjectID = s.TriggererSendDefinitionObjectID
    LEFT JOIN _JourneyActivity  AS ja 
        ON s.TriggererSendDefinitionObjectID = ja.JourneyActivityObjectID
    LEFT JOIN _Journey AS jy 
        ON ja.VersionID = jy.VersionID
WHERE
    s.EventDate > DATEADD(DD, -1, GETUTCDATE())
    AND jy.JourneyID = 'ED734C77-89E0-4D53-BE22-3912DE3CCC03' 
    AND (j.EmailName LIKE 'Email 1a%' or j.EmailName LIKE 'Email 1b%')
/*---- End - Onboarding - Members who entered the Free PT Onboarding Journey yesterday ----*/

UNION ALL

/*---- Begin - Onboarding - Members who entered the Paid PT Onboarding Journey yesterday----*/
SELECT
      s.SubscriberKey as CONTACTGUID,
      s.EventDate AT TIME ZONE 'Central America Standard Time' AT TIME ZONE 'UTC' AS date_entered
FROM _Job AS j
    LEFT JOIN _Sent AS s 
        ON j.JobID = s.JobID 
        AND j.TriggererSendDefinitionObjectID = s.TriggererSendDefinitionObjectID
    LEFT JOIN _JourneyActivity  AS ja 
        ON s.TriggererSendDefinitionObjectID = ja.JourneyActivityObjectID
    LEFT JOIN _Journey AS jy 
        ON ja.VersionID = jy.VersionID
WHERE
    s.EventDate > DATEADD(DD, -1, GETUTCDATE())
    AND jy.JourneyID = '82F978B8-3A5A-47A2-8AAC-EFFC682B59C8'
    AND j.EmailName LIKE 'Email 3%'
/*---- End - Onboarding - Members who entered the Paid PT Onboarding Journey yesterday  ----*/