--- description: Get daily average RUM statistics
--- Authorization: none
--- Access-Control-Allow-Origin: *
--- interval: 30
--- offset: 0
--- url: 
--- granularity: 1
--- timezone: UTC
--- domainkey: secret
WITH validkeys AS (
  SELECT hostname_prefix
  FROM `helix-225321.helix_reporting.domain_keys`
  WHERE
    key_bytes = SHA512(@domainkey)
    AND (revoke_date IS NULL OR revoke_date > CURRENT_DATE('UTC'))
)

SELECT
  drd.host,
  drd.repo,
  drd.avglcp,
  drd.avgfid,
  drd.avgcls,
  drd.month,
  drd.day,
  drd.year
FROM `helix-225321.mrosier_test.daily_rum_data` AS drd
INNER JOIN
  validkeys
  ON
    REGEXP_REPLACE(drd.host, 'www.', '') = validkeys.hostname_prefix
    OR validkeys.hostname_prefix = ''
ORDER BY
  drd.host,
  drd.month,
  drd.day,
  drd.year
