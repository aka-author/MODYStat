

with
    diagnosis
        as
    (select
        c.uuid,
        c.last_name,
        c.sex,
        statistics.age_months(
            c.age_when_disorders_were_found_years,
            c.age_when_disorders_were_found_months) as age_when_disorders_were_found_months,
        effective_diagnosis
    from
        statistics.cases c
            join
        statistics.effective_diagnosis e
            on
        c.final_diagnosis = e.source_diagnosis)
select
       d.uuid,
       (array_agg(d.last_name))[1] as last_name,
       (array_agg(d.sex))[1] as sex,
       (array_agg(d.age_when_disorders_were_found_months))[1] as age_when_disorders_were_found_months,
       (array_agg(d.effective_diagnosis))[1] as effective_diagnosis,
       statistics.dgroup_M3vsM2((array_agg(d.effective_diagnosis))[1]) as M3vsM2,
       avg(glycated_hemoglobin_for_diagnosis_hba1c) as glycated_hemoglobin_for_diagnosis_hba1c,
       avg(glucose_fasting_max) as glucose_fasting_max,
       avg(birth_height) as birth_height,
       avg(birth_weight) as birth_weight,
       avg(insulin_with_breakfast_test_fasting) as insulin_with_breakfast_test_fasting,
       avg(statistics.choose_preferred_real(
            ogtt_c_peptide_test_fasting,
            c_peptide_with_breakfast_test_fasting)) as c_peptide_with_test_fasting,
       avg(IAA_to_insulin) as IAA_to_insulin,
       avg(ICA_to_pancreatic_beta_cells) as ICA_to_pancreatic_beta_cells,
       avg(GAD_glutamate_decarboxylase) as GAD_glutamate_decarboxylase,
       avg(IA2_to_tyrosine_phosphatase) as IA2_to_tyrosine_phosphatase,
       avg(ZnT8_to_zinc_transporter) as ZnT8_to_zinc_transporter,
       max(HLA_gt_1_DRB1) as HLA_gt_1_DRB1,
       max(HLA_gt_1_DQA1) as HLA_gt_1_DQA1,
       max(HLA_gt_1_DQB1) as HLA_gt_1_DQB1,
       max(HLA_gt_2_DRB1) as HLA_gt_2_DRB1,
       max(HLA_gt_2_DQA1) as HLA_gt_1_DRB1,
       max(HLA_gt_2_DQB1) as HLA_gt_2_DQB1,
       statistics.haplotype(max(HLA_gt_1_DRB1), max(HLA_gt_1_DQA1), max(HLA_gt_1_DQB1)) as haplotype1,
       statistics.haplotype(max(HLA_gt_2_DRB1), max(HLA_gt_2_DQA1), max(HLA_gt_2_DQB1)) as haplotype2
    from
        diagnosis d,
        statistics.observations o
    where
        d.uuid = o.case_uuid
    group by
        d.uuid;


with
    diagnosis
        as
    (select
        c.uuid,
        c.last_name,
        c.sex,
        statistics.age_months(
            c.age_when_disorders_were_found_years,
            c.age_when_disorders_were_found_months) as age_when_disorders_were_found_months,
        effective_diagnosis
    from
        statistics.cases c
            join
        statistics.effective_diagnosis e
            on
        c.final_diagnosis = e.source_diagnosis),
    haplotypes
        as
    (select
       d.uuid,
       (array_agg(d.last_name))[1] as last_name,
       (array_agg(d.sex))[1] as sex,
       (array_agg(d.effective_diagnosis))[1] as effective_diagnosis,
       statistics.haplotype(max(HLA_gt_1_DRB1), max(HLA_gt_1_DQA1), max(HLA_gt_1_DQB1)) as haplotype1,
       statistics.haplotype(max(HLA_gt_2_DRB1), max(HLA_gt_2_DQA1), max(HLA_gt_2_DQB1)) as haplotype2
    from
        diagnosis d,
        statistics.observations o
    where
        d.uuid = o.case_uuid
    group by
        d.uuid)
select
    haplotype1,
    haplotype2,
    case when effective_diagnosis='СД1' then 1 end as sd1,
    case when effective_diagnosis ~* 'MODY.*' then 1 end as mody
    from
        haplotypes
    where
        haplotype1 is not null;


with
    diagnosis
        as
    (select
        c.uuid,
        c.last_name,
        c.sex,
        statistics.age_months(
            c.age_when_disorders_were_found_years,
            c.age_when_disorders_were_found_months) as age_when_disorders_were_found_months,
        effective_diagnosis
    from
        statistics.cases c
            join
        statistics.effective_diagnosis e
            on
        c.final_diagnosis = e.source_diagnosis),
    haplotypes
        as
    (select
       d.uuid,
       (array_agg(d.last_name))[1] as last_name,
       (array_agg(d.sex))[1] as sex,
       (array_agg(d.effective_diagnosis))[1] as effective_diagnosis,
       statistics.haplotype(max(HLA_gt_1_DRB1), max(HLA_gt_1_DQA1), max(HLA_gt_1_DQB1)) as haplotype1,
       statistics.haplotype(max(HLA_gt_2_DRB1), max(HLA_gt_2_DQA1), max(HLA_gt_2_DQB1)) as haplotype2
    from
        diagnosis d,
        statistics.observations o
    where
        d.uuid = o.case_uuid
    group by
        d.uuid),
    haplotypes_mono
        as
    (select
        haplotype1,
        case when haplotype1 <> haplotype2 then haplotype2 end as haplotype2,
        case when effective_diagnosis='СД1' then 1 else 0 end as sd1,
        case when effective_diagnosis ~* 'MODY.*' then 1 else 0 end as mody,
        case when not(effective_diagnosis='СД1' or effective_diagnosis ~* 'MODY.*') then 1 else 0 end as other
        from
            haplotypes
        where
            haplotype1 is not null),
    h1
        as
    (select gen_random_uuid() as uuid, haplotype1 as haplotype, sd1, mody, other from haplotypes_mono),
    h2
       as
    (select gen_random_uuid() as uuid, haplotype2 as haplotype, sd1, mody, other from haplotypes_mono where haplotype2 is not null),
    common
        as
    ((select * from h1) union (select * from h2))
    select
        --haplotype, count(uuid) as cnt, (sum(sd1)::real/count(uuid)::real) as sd1, (sum(mody)::real/count(uuid)::real) as mody
        haplotype, count(uuid) as cnt, sum(sd1) as sd1, sum(mody) as mody, sum(other) as other
        from
            common
        group by haplotype
        having count(uuid) > 5
