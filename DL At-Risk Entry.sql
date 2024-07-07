SELECT
      m.CONTACTGUID as CONTACTGUID
    , c.GENERALMANAGER as GENERALMANAGER
    , m.LASTATTENDDATE as LASTATTENDDATE
    , p.DAYSTOOBLIGATION as DAYSTOOBLIGATION
    , p.PropensityScoreCountDate as PropensityScoreCountDate
    , m.LATESTJOINDATE as LATESTJOINDATE
    , m.EMAILADDRESS as EMAILADDRESS
    , m.CURRENTPACKAGEMIX as CURRENTPACKAGEMIX
    , m.CLUBNAME as CLUBNAME
    , m.FIRSTNAME as FIRSTNAME
    , m.HOMECLUBID as HOMECLUBID
    , m.GENDER as GENDER
    ,p.ISCONTROLGROUP
    ,p.DECILES
FROM PRD_Members m
JOIN PRD_Club c ON m.HOMECLUBID = c.CLUBID
JOIN PRD_Propensity p ON m.CONTACTGUID = p.CONTACTGUID
WHERE (p.DECILES = 8 OR p.DECILES = 9 OR p.DECILES = 10) 
    AND 
        (p.DAYSTOOBLIGATION <= 334
        AND p.DAYSTOOBLIGATION >= 93)
    AND m.subscriptions_EMAILOPTIN = 'true'
    AND m.COUNTRYCODE = 'UK'
    AND c.CLUBBRAND IN ('David Lloyd', 'Virgin Active')
    AND m.LASTATTENDDATE IS NOT NULL
    AND m.CURRENTSTATUS = 'Package OK'
    AND p.ISCONTROLGROUP = 'Target'