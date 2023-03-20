{{ config(
  materialized='table',
   indexes=[
      {'columns': ['_airbyte_ab_id'], 'type': 'hash'}
    ],
    schema='intermediate'
) }}

select (_airbyte_data -> 'form' ->> 'visitreason') as visitreason,
(_airbyte_data -> 'form' ->> 'hvconduct') as conducted_by, 
(_airbyte_data ->> 'id') as id,
NULLIF((_airbyte_data -> 'form' ->> 'why_high_risk'),'') as why_high_risk,
COALESCE(NULLIF(_airbyte_data -> 'form' -> 'hbtrim3'->> 'gradetrim3',''),
NULLIF(_airbyte_data -> 'form' -> 'hbtrim2'->> 'gradetrim2',''),
NULLIF(_airbyte_data -> 'form' -> 'hbtrim1'->> 'gradetrim1','')) as hb_grade,
(_airbyte_data -> 'form' ->> 'referral') as referral,
(_airbyte_data -> 'form' ->> 'referral_reasoncats') as referral_reasons,
date(NULLIF(_airbyte_data -> 'form' ->> 'visitdate','')) as visitdate, 
(_airbyte_data -> 'form' ->> 'ANCTHR') as ancthr,
(_airbyte_data -> 'form' ->> 'ancreg') as anc_reg,
(_airbyte_data -> 'form' ->> 'ancregmonth') as anc_reg_trimester,
_airbyte_data -> 'form' ->> 'load_person_case_id' as caseid,
_airbyte_ab_id,
_airbyte_emitted_at
from {{ source('commcare_anc', 'raw_anc_visit') }} 
where (_airbyte_data -> 'form' ->> 'visitreason') = 'ANC' OR (_airbyte_data -> 'form' ->> 'visitreason') = 'Close_case'
AND (_airbyte_data ->> 'archived')::boolean = false
/*remove test data */
AND (_airbyte_data -> 'form' ->> 'womanname') NOT LIKE '%Demo%'