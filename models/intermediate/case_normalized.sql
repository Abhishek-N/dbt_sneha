{{ config(
  materialized='table',
   indexes=[
      {'columns': ['_airbyte_ab_id'], 'type': 'hash'}
    ],
    schema='intermediate'

) }}



select
        _airbyte_ab_id,
        _airbyte_emitted_at,
        _airbyte_data ->> 'id' as id,
        _airbyte_data ->> 'properties_womanid' as womanid,
        _airbyte_data ->> 'properties_womanname' as womanname,
    	  _airbyte_data ->>  'properties_clusterid' as clusterid,
    	  _airbyte_data ->>  'properties_center' as center,
    	  _airbyte_data ->> 'properties_coid' as coid,
    	  (_airbyte_data ->>  'closed')::boolean as closed,
    	  _airbyte_data ->>  'properties_anc_closereason' as anc_closereason,
    	  _airbyte_data ->>  'properties_high_risk_preg' as high_risk_preg,
    	  date(NULLIF(_airbyte_data ->>  'properties_lmpdate','')) as lmpdate,
    	  _airbyte_data ->>  'properties_referral' as referral,
    	  date(NULLIF(_airbyte_data ->>  'properties_referraldate','')) as referral_date,
    	  _airbyte_data ->>  'properties_referralplace' as referral_place,
    	  _airbyte_data ->>  'properties_referralreason' as referral_reason,
    	  _airbyte_data ->>  'properties_referralcategory' as referral_category,
    	  _airbyte_data ->>  'properties_prev_pregoutcome' as prev_pregoutcome,
        date(NULLIF(_airbyte_data ->> 'properties_finalWDOB','')) as  finalwdob,
        (_airbyte_data ->> 'properties_gravida_count')::int as  gravida_count,
        _airbyte_data ->> 'properties_referral_followupname' as  referral_followupname,
        _airbyte_data ->> 'properties_pregoutcome' as  pregoutcome,
        date(NULLIF(_airbyte_data ->> 'properties_delivery_date','')) as  delivery_date,
        _airbyte_data ->> 'properties_case_type' as  case_type,
        _airbyte_data ->> 'properties_why_high_risk' as  why_high_risk,
         _airbyte_data ->> 'properties_womengarde_cat' as  woman_bmi_grade


from {{ source('commcare_anc', 'raw_case') }}
where _airbyte_data ->> 'properties_case_type' = 'azmi_ancvisit'