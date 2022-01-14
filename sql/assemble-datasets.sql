with diagnosis as (
    select
        c.uuid,
        effective_diagnosis
    from
        statistics.cases c
            join
        statistics.effective_diagnosis e
            on
        c.final_diagnosis = e.source_diagnosis),
    initial_observations as (
        select * from statistics.observations where observation_no=1
    ),
    observation_totlals_by_cases as (
        select
            (array_agg(case_uuid))[1] as case_uuid_,
            count(case_uuid) as number_of_observations,
            max(observation_no) as latest_observation_no,
            max(treatment_insulin) as treatment_insulin,
            max(treatment_metformin) as treatment_metformin,
            max(treatment_liraglutide) as treatment_liraglutide,
            max(treatment_sulfonylurea) as treatment_sulfonylurea
        from
            statistics.observations o
        group by
            o.case_uuid
    ),
    latest_observations as (
        select *
        from
            statistics.observations o
                join
            observation_totlals_by_cases t
                on
            o.case_uuid = t.case_uuid_
                and
            o.observation_no = t.latest_observation_no
        where
            observation_no > 1
    ),
    clinical_cases as (
        select
            case_no,
            trim(last_name) as last_name,
            trim(first_name) as first_name,
            t.number_of_observations,
            effective_diagnosis,
            statistics.age_months(
                i.age_when_examination_years,
                i.age_when_examination_months) as age_when_initial_examination,
            statistics.age_months(
                l.age_when_examination_years,
                l.age_when_examination_months
                ) as age_when_latest_examination,
            statistics.age_months(
            c.age_when_disorders_were_found_years,
            c.age_when_disorders_were_found_months
                ) as age_when_disorders_were_found_months,
            i.birth_height as birth_height,
            i.birth_weight as birth_weight,
            i.glycated_hemoglobin_for_diagnosis_hba1c as i_glycated_hemoglobin_for_diagnosis_hba1c,
            l.glycated_hemoglobin_during_exm as l_glycated_hemoglobin_during_exm,
            i.glucose_fasting_max as i_glucose_fasting_max,
            l.glucose_fasting_max as l_glucose_fasting_max,
            i.insulin_with_breakfast_test_fasting as i_insulin_with_breakfast_test_fasting,
            l.insulin_with_breakfast_test_fasting as l_insulin_with_breakfast_test_fasting,
            statistics.choose_preferred_real(i.ogtt_c_peptide_test_fasting,
                l.c_peptide_with_breakfast_test_fasting
                ) as i_c_peptide_with_test_fasting,
            statistics.choose_preferred_real(
                l.ogtt_c_peptide_test_fasting,
                l.c_peptide_with_breakfast_test_fasting
                ) as l_c_peptide_with_test_fasting,
            t.treatment_sulfonylurea,
            t.treatment_liraglutide,
            t.treatment_metformin,
            t.treatment_insulin,

            t.treatment_sulfonylurea is not null
                or
            t.treatment_liraglutide is not null
                or
            t.treatment_metformin is not null
                or
            t.treatment_insulin is not null as received_treatment
        from
            statistics.cases c,
            initial_observations i,
            latest_observations l,
            observation_totlals_by_cases t,
            diagnosis d
        where
            c.uuid = i.case_uuid
                and
            c.uuid = l.case_uuid
                and
            c.uuid = t.case_uuid_
                and
            c.uuid = d.uuid
    )
    select *,
        statistics.case_data_quality(
    age_when_disorders_were_found_months,
    birth_height,
    birth_weight,
    i_glycated_hemoglobin_for_diagnosis_hba1c,
    l_glycated_hemoglobin_during_exm,
    i_glucose_fasting_max,
    l_glucose_fasting_max ,
    i_insulin_with_breakfast_test_fasting,
    l_insulin_with_breakfast_test_fasting,
    i_c_peptide_with_test_fasting,
    l_c_peptide_with_test_fasting) as data_quality

    from
        clinical_cases
    order by
        data_quality desc;






select * from final_observations;

select (array_agg(case_uuid))[1] as uuid, max(observation_no)
        from
            statistics.observations o
        where
            observation_no > 1
        group by
            o.case_uuid