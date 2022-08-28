create or replace function statistics.parse_bool(bool_as_str varchar,
                                                 str_true varchar default 'yes',
                                                 str_false varchar default 'no',
                                                 default_value bool default null) returns bool
    language plpgsql as $$
    declare
        bool_as_str_pure varchar;
        str_true_pure varchar;
        str_false_pure varchar;
    begin
        bool_as_str_pure = upper(trim(bool_as_str));
        str_true_pure = upper(trim(str_true));
        str_false_pure = upper(trim(str_false));
        if bool_as_str_pure = str_true_pure
            then return true;
        end if;
        if bool_as_str_pure = str_false_pure
            then return false;
        end if;
        return default_value;
    end $$;


create or replace function statistics.parse_int(int_as_str varchar,
                                                format varchar default '9999999') returns int
    language plpgsql as $$
    declare
        int_as_str_pure varchar;
    begin
        int_as_str_pure = trim(int_as_str);
        if int_as_str ~ '^\d+$'
            then return to_number(int_as_str, format);
            else return null;
        end if;
    end $$;


create or replace function statistics.parse_real(real_as_str varchar,
                                                 format varchar default '9999999D999999') returns real
    language plpgsql as $$
    declare
        real_as_str_pure varchar;
    begin
        real_as_str_pure = trim(real_as_str);
        if real_as_str ~ '^(\d+)((,\d*)?)$'
            then return to_number(real_as_str, format);
            else return null;
        end if;
    end $$;


create or replace function statistics.parse_sex(sex_as_str varchar,
                                                str_male varchar,
                                                str_female varchar) returns char
    language plpgsql as $$
    declare
        sex_as_str_pure varchar;
        str_male_pure varchar;
        str_female_pure varchar;
    begin
        sex_as_str_pure = upper(trim(sex_as_str));
        str_male_pure = upper(trim(str_male));
        str_female_pure = upper(trim(str_female));

        return
            case
                when sex_as_str_pure = str_male_pure then 'M'
                when sex_as_str_pure = str_female_pure then 'F'
            end;
    end $$;


create or replace function statistics.guarantee_int(num numeric) returns int
    language plpgsql as $$
    begin
        if num is not null
            then return num;
            else return 0;
        end if;
    end $$;




create or replace function statistics.choose_preferred_real(preferred real, fallback real) returns real
    language plpgsql as $$
    begin
        if preferred is not null
            then return preferred;
            else return fallback;
        end if;
    end $$;


create or replace function statistics.field_data_quality(field anyelement, score int default 1) returns int
    language plpgsql as $$
    begin
        if field is not null
            then return score;
            else return 0;
        end if;
    end $$;


create or replace function statistics.case_data_quality(
    age_when_disorders_were_found_months numeric,
    birth_height int,
    birth_weight int,
    i_glycated_hemoglobin_for_diagnosis_hba1c real,
    l_glycated_hemoglobin_during_exm real,
    i_glucose_fasting_max real,
    l_glucose_fasting_max real,
    i_insulin_with_breakfast_test_fasting real,
    l_insulin_with_breakfast_test_fasting real,
    i_c_peptide_with_test_fasting real,
    l_c_peptide_with_test_fasting real) returns numeric
    language plpgsql as $$
    begin
        return
            statistics.field_data_quality(age_when_disorders_were_found_months) +
            statistics.field_data_quality(birth_height) +
            statistics.field_data_quality(birth_weight) +
            statistics.field_data_quality(i_glycated_hemoglobin_for_diagnosis_hba1c) +
            statistics.field_data_quality(l_glycated_hemoglobin_during_exm) +
            statistics.field_data_quality(i_glucose_fasting_max) +
            statistics.field_data_quality(l_glucose_fasting_max) +
            statistics.field_data_quality(i_insulin_with_breakfast_test_fasting) +
            statistics.field_data_quality(l_insulin_with_breakfast_test_fasting) +
            statistics.field_data_quality(i_c_peptide_with_test_fasting) +
            statistics.field_data_quality(l_c_peptide_with_test_fasting);
    end $$;


create or replace function statistics.initial_observation_data_quality(
    age_when_disorders_were_found_months numeric,
    birth_height int,
    birth_weight int,
    glycated_hemoglobin_for_diagnosis_hba1c real,
    glucose_fasting_max real,
    insulin_with_breakfast_test_fasting real,
    c_peptide_with_test_fasting real,
    IAA_to_insulin real,
	ICA_to_pancreatic_beta_cells real,
	GAD_glutamate_decarboxylase real,
	IA2_to_tyrosine_phosphatase real,
	ZnT8_to_zinc_transporter real,
	HLA_gt_1_DRB1 real,
	HLA_gt_1_DQA1 real,
	HLA_gt_1_DQB1 real,
	HLA_gt_2_DRB1 real,
	HLA_gt_2_DQA1 real,
	HLA_gt_2_DQB1 real) returns numeric
    language plpgsql as $$
    begin
        return
            100*(statistics.field_data_quality(age_when_disorders_were_found_months) +
            statistics.field_data_quality(birth_height) +
            statistics.field_data_quality(birth_weight) +
            statistics.field_data_quality(glycated_hemoglobin_for_diagnosis_hba1c) +
            statistics.field_data_quality(glucose_fasting_max) +
            statistics.field_data_quality(insulin_with_breakfast_test_fasting) +
            statistics.field_data_quality(c_peptide_with_test_fasting) +
            statistics.field_data_quality(IAA_to_insulin) +
            statistics.field_data_quality(ICA_to_pancreatic_beta_cells) +
            statistics.field_data_quality(GAD_glutamate_decarboxylase) +
            statistics.field_data_quality(IA2_to_tyrosine_phosphatase) +
            statistics.field_data_quality(ZnT8_to_zinc_transporter) +
            statistics.field_data_quality(HLA_gt_1_DRB1) +
            statistics.field_data_quality(HLA_gt_1_DQA1) +
            statistics.field_data_quality(HLA_gt_1_DQB1) +
            statistics.field_data_quality(HLA_gt_2_DRB1) +
            statistics.field_data_quality(HLA_gt_2_DQA1) +
            statistics.field_data_quality(HLA_gt_2_DQB1))/18;
    end $$;


create or replace function statistics.age_months(years int, months int) returns int
    language plpgsql as $$
    begin
        return statistics.guarantee_int(years)*12 + statistics.guarantee_int(months);
    end $$;


create or replace function statistics.age_delta_months(years_start int, months_start int,
                                                       years_final int, months_final int) returns int
    language plpgsql as $$
    begin
        return
            (statistics.guarantee_int(years_final) - statistics.guarantee_int(years_start))*12 +
             statistics.guarantee_int(months_final) - statistics.guarantee_int(months_start);
    end $$;


create or replace function statistics.haplotype(a1 varchar, a2 varchar, a3 varchar) returns varchar
	language plpgsql as $$
	begin
        if a1 is not null and a2 is not null and a3 is not null
		then return concat(a1, ':', a2, ':', a3);
		else return null;
		end if;
	end $$;

create or replace function statistics.dgroup_M3vsM2(d varchar) returns varchar
	language plpgsql as $$
	begin
        if d in ('СД1', 'MODY3', 'DIDMOAD')
		    then return 'СД1_MODY2_DIDMOAD';
		elseif d in ('MODY2', 'ДИГ', 'Альстрем', 'СД2', 'MODY')
		    then return 'MODY2_ДИГ_Альстрем_СД2_ MODY';
		else
            return '';
		end if;
	end $$;


create or replace function statistics.useful_max(v1 real, v2 real) returns real
language plpgsql as $$
begin
    if v1 is not null and v2 is null
        then return v1;
    elseif v1 is null and v2 is not null
        then return v2;
    elseif v1 is not null and v2 is not null
        then begin
            if v1 > v1 then return v1; else return v2; end if;
        end;
    else return null;
    end if;
end $$;




create or replace function statistics.degree(
        glucose_fasting_max real, OGTT_glucose_test_fasting real,
        OGTT_glucose_test_120 real, postprandial_glucose_after_meals_max real) returns varchar
    language plpgsql as $$
    declare
        glucose1 real;
        degree1 varchar;
        glucose2 real;
        degree2 varchar;
        degree varchar;
	begin
        if glucose_fasting_max is not null
            then glucose1 = glucose_fasting_max;
            else glucose1 = OGTT_glucose_test_fasting;
        end if;

        degree1 = null;
        if glucose1 is not null then
            if glucose1 < 6 then degree1 = 'Здоров';
                elseif glucose1 < 7 then degree1 = 'НГН';
                else degree1 = 'СД';
            end if;
        end if;

        if OGTT_glucose_test_120 is not null
            then glucose2 = OGTT_glucose_test_120;
            else glucose2 = postprandial_glucose_after_meals_max;
        end if;

        degree2 = null;
        if glucose2 is not null then
            if glucose2 < 7.8 then degree2 = 'Здоров';
                elseif glucose2 < 11 then degree2 = 'НТГ';
                else degree2 = 'СД';
            end if;
        end if;

        degree = null;
        if degree1 is not null and degree1 is not null then
            if degree1 = 'СД' or degree2 = 'СД'
                then degree = '3. СД';
                elseif degree1 = 'НГН' and degree2 = 'НТГ'
                    then degree = '2. НГН НТГ';
                elseif degree1 = 'НГН'
                    then degree = '1. НГН';
                elseif degree2 = 'НТГ'
                    then degree = '1. НТГ';
                else degree = '0. Здоров';
            end if;
        end if;

        return degree;
	end $$;



create table statistics.effective_diagnosis (
    uuid                uuid default gen_random_uuid() not null primary key,
    source_diagnosis    varchar(255),
    effective_diagnosis varchar(255),
    comment             varchar
);


create table statistics.outcomes (
    uuid                uuid default gen_random_uuid() not null primary key,
    code                int,
    outcome_name        varchar(255),
    comment             varchar
);


create table statistics.treatment_modes (
    uuid                uuid default gen_random_uuid() not null primary key,
    code                int,
    treatment_mode_name varchar(255),
    comment             varchar
);


create table statistics.cases (
	uuid 				                    uuid default gen_random_uuid() not null primary key,
	case_no 			                    varchar(36),
	last_name 			                    varchar(255),
	first_name 			                    varchar(255),
	otchestvo 			                    varchar(255),
	sex 				                    varchar(1),
	date_of_birth 		                    date,
	age_when_disorders_were_found_years     int,
    age_when_disorders_were_found_months    int,
	final_diagnosis 	                    varchar(255),
    comment 	                            varchar
);


create table statistics.observations (
	uuid 											uuid default gen_random_uuid() not null primary key,
	case_uuid                                       uuid references statistics.cases (uuid),
	observation_no 									int,
	age_when_examination_years 						int,
	age_when_examination_months 					int,
	age_when_disorders_were_found_years 			int,
	age_when_disorders_were_found_months 			int,
	ketosis_at_manifestation 						boolean,
	polyuria 										boolean,
	polydipsia 										boolean,
	glucosuria 										boolean,
	weight_loss 									boolean,
	healthy 										boolean,
	gestational_diabetes							boolean,
	glucose_intolerance 							boolean,
	violation_of_glycemia_fasting 					boolean,
	diabetes 										boolean,
	birth_height 									int,
	birth_weight 									int,
	height_sds 										real,
	weight_sds 										real,
	body_mass_index_sds 							real,
	cholesterol 									real,
	triglycerides 									real,
	duration_of_carbohydrate_metabolism_disorders 	int,
	glycated_hemoglobin_for_diagnosis_HbA1C 		real,
	glycated_hemoglobin_during_exm 					real,
	degree_of_carbohydrate_metabolism_disorder 		varchar,
	preliminary_diagnosis 							varchar,
	diagnosis_on_examination 						varchar,
	accompanying_illnesses 							varchar,
	complications_of_diabetes 						varchar,
	treatment_shortdesc 							varchar,
	treatment_diet 									varchar,
	treatment_insulin 								real,
	treatment_liraglutide 							real,
	treatment_metformin 							real,
	treatment_sulfonylurea 							real,
	glucose_fasting_min 							real,
	glucose_fasting_max 							real,
	postprandial_glucose_after_meals_max 			real,
	OGTT_glucose_test_fasting 						real,
	OGTT_glucose_test_30 							real,
	OGTT_glucose_test_60 							real,
	OGTT_glucose_test_90 							real,
	OGTT_glucose_test_120 							real,
	OGTT_insulin_test_fasting 						real,
	OGTT_insulin_test_30 							real,
	OGTT_insulin_test_60 							real,
	OGTT_insulin_test_90 							real,
	OGTT_insulin_test_120 							real,
	OGTT_C_peptide_test_fasting 					real,
	OGTT_C_peptide_test_30 							real,
	OGTT_C_peptide_test_60 							real,
	OGTT_C_peptide_test_90 							real,
	OGTT_C_peptide_test_120 						real,
	glucose_with_breakfast_test_fasting 			real,
	glucose_with_breakfast_test_30 					real,
	glucose_with_breakfast_test_60 					real,
	glucose_with_breakfast_test_90 					real,
	glucose_with_breakfast_test_120 				real,
	insulin_with_breakfast_test_fasting 			real,
	insulin_with_breakfast_test_30 					real,
	insulin_with_breakfast_test_60 					real,
	insulin_with_breakfast_test_90 					real,
	insulin_with_breakfast_test_120 				real,
	c_peptide_with_breakfast_test_fasting 			real,
	c_peptide_with_breakfast_test_30 				real,
	c_peptide_with_breakfast_test_60 				real,
	c_peptide_with_breakfast_test_90 				real,
	c_peptide_with_breakfast_test_120 				real,
	IAA_to_insulin 									real,
	ICA_to_pancreatic_beta_cells 					real,
	GAD_glutamate_decarboxylase 					real,
	IA2_to_tyrosine_phosphatase 					real,
	ZnT8_to_zinc_transporter 						real,
	HLA_gt_1_DRB1 									varchar,
	HLA_gt_1_DQA1 									varchar,
	HLA_gt_1_DQB1 									varchar,
	HLA_gt_2_DRB1 									varchar,
	HLA_gt_2_DQA1 									varchar,
	HLA_gt_2_DQB1 									varchar,
	notes_on_trees 									varchar,
	memo1 										    varchar,
	memo2 										    varchar,
	gene 											varchar,
	mutation                                        varchar,
	comment	 							            varchar
);

/* */
create table statistics.source_observations (
	uuid 											uuid default gen_random_uuid() not null primary key,
	case_no 										varchar(36),
	examination_no 									int,
	last_name 										varchar(255),
	first_name 										varchar(255),
	otchestvo 										varchar(255),
	sex 											char(1),
	date_of_birth 									date,
	age_when_examination_years 						varchar,
	age_when_examination_months 					varchar,
	age_when_disorders_were_found_years 			varchar,
	age_when_disorders_were_found_months 			varchar,
	ketosis_at_manifestation 						varchar(255),
	polyuria 										varchar(255),
	polydipsia 										varchar(255),
	glucosuria 										varchar(255),
	weight_loss 									varchar(255),
	healthy 										varchar(255),
	gestational_diabetes 							varchar(255),
	glucose_intolerance 							varchar(255),
	violation_of_glycemia_fasting 					varchar(255),
	diabetes 										varchar(255),
	birth_height 									int,
	birth_weight 									int,
	height_sds 										real,
	weight_sds 										real,
	body_mass_index_sds 							real,
	cholesterol 									real,
	triglycerides 									real,
	duration_of_carbohydrate_metabolism_disorders 	int,
	glycated_hemoglobin_for_diagnosis_HbA1C 		real,
	glycated_hemoglobin_during_exm 					real,
	degree_of_carbohydrate_metabolism_disorder 		varchar(255),
	preliminary_diagnosis 							varchar(255),
	diagnosis_on_examination 						varchar(255),
	accompanying_illnesses 							varchar(255),
	complications_of_diabetes 						varchar(255),
	treatment_shortdesc 							varchar(255),
	treatment_diet 									varchar(255),
	treatment_insulin 								real,
	treatment_liraglutide 							real,
	treatment_metformin 							real,
	treatment_sulfonylurea 							real,
	glucose_fasting_min 							real,
	glucose_fasting_max 							real,
	postprandial_glucose_after_meals_max 			real,
	OGTT_glucose_test_fasting 						real,
	OGTT_glucose_test_30 							real,
	OGTT_glucose_test_60 							real,
	OGTT_glucose_test_90 							real,
	OGTT_glucose_test_120 							real,
	OGTT_insulin_test_fasting 						real,
	OGTT_insulin_test_30 							real,
	OGTT_insulin_test_60 							real,
	OGTT_insulin_test_90 							real,
	OGTT_insulin_test_120 							real,
	OGTT_C_peptide_test_fasting 					real,
	OGTT_C_peptide_test_30 							real,
	OGTT_C_peptide_test_60 							real,
	OGTT_C_peptide_test_90 							real,
	OGTT_C_peptide_test_120 						real,
	glucose_with_breakfast_test_fasting 			real,
	glucose_with_breakfast_test_30 					real,
	glucose_with_breakfast_test_60 					real,
	glucose_with_breakfast_test_90 					real,
	glucose_with_breakfast_test_120 				real,
	insulin_with_breakfast_test_fasting 			real,
	insulin_with_breakfast_test_30 					real,
	insulin_with_breakfast_test_90 					real,
	insulin_with_breakfast_test_120 				real,
	c_peptide_with_breakfast_test_fasting 			real,
	c_peptide_with_breakfast_test_30 				real,
	c_peptide_with_breakfast_test_60 				real,
	c_peptide_with_breakfast_test_90 				real,
	c_peptide_with_breakfast_test_120 				real,
	IAA_to_insulin 									real,
	ICA_to_pancreatic_beta_cells 					real,
	GAD_glutamate_decarboxylase 					real,
	IA2_to_tyrosine_phosphatase 					real,
	ZnT8_to_zinc_transporter 						real,
	HLA_gt_1_DRB1 									varchar,
	HLA_gt_1_DQA1 									varchar,
	HLA_gt_1_DQB1 									varchar,
	HLA_gt_2_DRB1 									varchar,
	HLA_gt_2_DQA1 									varchar,
	HLA_gt_2_DQB1 									varchar,
	notes_on_trees 									varchar,
	final_diagnosis 								varchar(255),
	memo1 											varchar,
	memo2 											varchar,
	gene 											varchar(255),
	mutation 										varchar(255)
);


create table statistics.imported_observations_raw (
	case_no 										varchar,
	observation_no 									varchar,
	last_name 										varchar,
	first_name 										varchar,
	otchestvo 										varchar,
	sex 											varchar,
	date_of_birth 									varchar,
	age_when_observation_years 						varchar,
	age_when_observation_months 					varchar,
	age_when_disorders_were_found_years 			varchar,
	age_when_disorders_were_found_months 			varchar,
	ketosis_at_manifestation 						varchar,
	polyuria 										varchar,
	polydipsia 										varchar,
	glucosuria 										varchar,
	weight_loss 									varchar,
	healthy 										varchar,
	gestational_diabetes 							varchar,
	glucose_intolerance 							varchar,
	violation_of_glycemia_fasting 					varchar,
	diabetes 										varchar,
	birth_height 									varchar,
	birth_weight 									varchar,
	height_sds 										varchar,
	weight_sds 										varchar,
	body_mass_index_sds 							varchar,
	cholesterol 									varchar,
	triglycerides 									varchar,
	duration_of_carbohydrate_metabolism_disorders 	varchar,
	glycated_hemoglobin_for_diagnosis_HbA1C 		varchar,
	glycated_hemoglobin_during_exm 					varchar,
	degree_of_carbohydrate_metabolism_disorder 		varchar,
	preliminary_diagnosis 							varchar,
	diagnosis_on_examination 						varchar,
	accompanying_illnesses 							varchar,
	complications_of_diabetes 						varchar,
	treatment_shortdesc 							varchar,
	treatment_diet 									varchar,
	treatment_insulin 								varchar,
	treatment_liraglutide 							varchar,
	treatment_metformin 							varchar,
	treatment_sulfonylurea 							varchar,
	glucose_fasting_min 							varchar,
	glucose_fasting_max 							varchar,
	postprandial_glucose_after_meals_max 			varchar,
	OGTT_glucose_test_fasting 						varchar,
	OGTT_glucose_test_30 							varchar,
	OGTT_glucose_test_60 							varchar,
	OGTT_glucose_test_90 							varchar,
	OGTT_glucose_test_120 							varchar,
	OGTT_insulin_test_fasting 						varchar,
	OGTT_insulin_test_30 							varchar,
	OGTT_insulin_test_60 							varchar,
	OGTT_insulin_test_90 							varchar,
	OGTT_insulin_test_120 							varchar,
	OGTT_C_peptide_test_fasting 					varchar,
	OGTT_C_peptide_test_30 							varchar,
	OGTT_C_peptide_test_60 							varchar,
	OGTT_C_peptide_test_90 							varchar,
	OGTT_C_peptide_test_120 						varchar,
	glucose_with_breakfast_test_fasting 			varchar,
	glucose_with_breakfast_test_30 					varchar,
	glucose_with_breakfast_test_60 					varchar,
	glucose_with_breakfast_test_90 					varchar,
	glucose_with_breakfast_test_120 				varchar,
	insulin_with_breakfast_test_fasting 			varchar,
	insulin_with_breakfast_test_30 					varchar,
	insulin_with_breakfast_test_60 					varchar,
	insulin_with_breakfast_test_90 					varchar,
	insulin_with_breakfast_test_120 				varchar,
	c_peptide_with_breakfast_test_fasting 			varchar,
	c_peptide_with_breakfast_test_30 				varchar,
	c_peptide_with_breakfast_test_60 				varchar,
	c_peptide_with_breakfast_test_90 				varchar,
	c_peptide_with_breakfast_test_120 				varchar,
	IAA_to_insulin 									varchar,
	ICA_to_pancreatic_beta_cells 					varchar,
	GAD_glutamate_decarboxylase 					varchar,
	IA2_to_tyrosine_phosphatase 					varchar,
	ZnT8_to_zinc_transporter 						varchar,
	HLA_gt_1_DRB1 									varchar,
	HLA_gt_1_DQA1 									varchar,
	HLA_gt_1_DQB1 									varchar,
	HLA_gt_2_DRB1 									varchar,
	HLA_gt_2_DQA1 									varchar,
	HLA_gt_2_DQB1 									varchar,
	notes_on_trees 									varchar,
	final_diagnosis 								varchar,
	memo1 											varchar,
	memo2 											varchar,
	gene 											varchar,
	mutation 										varchar
);


create table statistics.haplotypes (
	uuid 			uuid default gen_random_uuid() not null primary key,
	title			varchar,
	alleles			json
);


create or replace view statistics.cases_extended
    as
        select
            c.uuid,
            c.case_no,
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
            c.final_diagnosis = e.source_diagnosis;


create or replace view statistics.observations_extended
    as
        select *,
            statistics.haplotype(hla_gt_1_drb1, hla_gt_1_dqa1, hla_gt_1_dqb1) as haplotype1,
            statistics.haplotype(hla_gt_2_drb1, hla_gt_2_dqa1, hla_gt_2_dqb1) as haplotype2,
            statistics.degree(glucose_fasting_max, OGTT_glucose_test_fasting,
                              OGTT_glucose_test_120, postprandial_glucose_after_meals_max) as degree
        from
            statistics.observations
        where
            statistics.age_months(age_when_examination_years, age_when_examination_months) <= 25*12;


drop view statistics.flat_cases;

create view statistics.flat_cases
    as
    select
       d.uuid,
       (array_agg(d.case_no))[1] as case_no,
       (array_agg(d.last_name))[1] as last_name,
       (array_agg(d.sex))[1] as sex,
       (array_agg(d.age_when_disorders_were_found_months))[1] as age_when_disorders_were_found_months,
       max(d.effective_diagnosis) as effective_diagnosis,
       --(array_agg(d.effective_diagnosis))[1] as effective_diagnosis,
       statistics.dgroup_M3vsM2((array_agg(d.effective_diagnosis))[1]) as M3vsM2,
       avg(glycated_hemoglobin_for_diagnosis_hba1c) as glycated_hemoglobin_for_diagnosis_hba1c,
       avg(birth_height) as birth_height,
       avg(birth_weight) as birth_weight,
       avg(statistics.choose_preferred_real(
            ogtt_c_peptide_test_fasting,
            c_peptide_with_breakfast_test_fasting)) as c_peptide_with_test_fasting,
       avg(body_mass_index_sds) as body_mass_index_sds,
       avg(glucose_fasting_min) as glucose_fasting_min,
       avg(glucose_fasting_max) as glucose_fasting_max,
       avg(postprandial_glucose_after_meals_max) as postprandial_glucose_after_meals_max,
       avg(OGTT_glucose_test_fasting) as OGTT_glucose_test_fasting,
       avg(OGTT_glucose_test_30) as OGTT_glucose_test_30,
       avg(OGTT_glucose_test_60) as OGTT_glucose_test_60,
       avg(OGTT_glucose_test_90) as OGTT_glucose_test_90,
       avg(OGTT_glucose_test_120) as OGTT_glucose_test_120,
       avg(OGTT_insulin_test_fasting) as OGTT_insulin_test_fasting,
       avg(OGTT_insulin_test_30) as OGTT_insulin_test_30,
       avg(OGTT_insulin_test_60) as OGTT_insulin_test_60,
       avg(OGTT_insulin_test_90) as OGTT_insulin_test_90,
       avg(OGTT_insulin_test_120) as OGTT_insulin_test_120,
       avg(OGTT_C_peptide_test_fasting) as OGTT_C_peptide_test_fasting,
       avg(OGTT_C_peptide_test_30) as OGTT_C_peptide_test_30,
       avg(OGTT_C_peptide_test_60) as OGTT_C_peptide_test_60,
       avg(OGTT_C_peptide_test_90) as OGTT_C_peptide_test_90,
       avg(OGTT_C_peptide_test_120) as OGTT_C_peptide_test_120,
       avg(glucose_with_breakfast_test_fasting) as glucose_with_breakfast_test_fasting,
       avg(glucose_with_breakfast_test_30) as glucose_with_breakfast_test_30,
       avg(glucose_with_breakfast_test_60) as glucose_with_breakfast_test_60,
       avg(glucose_with_breakfast_test_90) as glucose_with_breakfast_test_90,
       avg(glucose_with_breakfast_test_120) as glucose_with_breakfast_test_120,
       avg(insulin_with_breakfast_test_fasting) as insulin_with_breakfast_test_fasting,
       avg(insulin_with_breakfast_test_30) as insulin_with_breakfast_test_30,
       avg(insulin_with_breakfast_test_60) as insulin_with_breakfast_test_60,
       avg(insulin_with_breakfast_test_90) as insulin_with_breakfast_test_90,
       avg(insulin_with_breakfast_test_120) as insulin_with_breakfast_test_120,
       avg(c_peptide_with_breakfast_test_fasting) as c_peptide_with_breakfast_test_fasting,
       avg(c_peptide_with_breakfast_test_30) as c_peptide_with_breakfast_test_30,
       avg(c_peptide_with_breakfast_test_60) as c_peptide_with_breakfast_test_60,
       avg(c_peptide_with_breakfast_test_90) as c_peptide_with_breakfast_test_90,
       avg(c_peptide_with_breakfast_test_120) as c_peptide_with_breakfast_test_120,
       avg(IAA_to_insulin) as IAA_to_insulin,
       avg(ICA_to_pancreatic_beta_cells) as ICA_to_pancreatic_beta_cells,
       avg(GAD_glutamate_decarboxylase) as GAD_glutamate_decarboxylase,
       avg(IA2_to_tyrosine_phosphatase) as IA2_to_tyrosine_phosphatase,
       avg(ZnT8_to_zinc_transporter) as ZnT8_to_zinc_transporter,
       max(haplotype1) as haplotype1,
       max(haplotype2) as haplotype2,
       max(degree) as degree
    from
        statistics.cases_extended d,
        statistics.observations_extended o
    where
        d.uuid = o.case_uuid
    group by
        d.uuid;


drop view statistics.flat_diagnosis;

create view statistics.flat_diagnosis
    as
    select
       effective_diagnosis,
       count(*),
       avg(glycated_hemoglobin_for_diagnosis_hba1c) as glycated_hemoglobin_for_diagnosis_hba1c,
       avg(birth_height) as birth_height,
       avg(birth_weight) as birth_weight,
       avg(body_mass_index_sds) as body_mass_index_sds,
       avg(glucose_fasting_min) as glucose_fasting_min,
       avg(glucose_fasting_max) as glucose_fasting_max,
       avg(postprandial_glucose_after_meals_max) as postprandial_glucose_after_meals_max,
       avg(OGTT_glucose_test_fasting) as OGTT_glucose_test_fasting,
       avg(OGTT_glucose_test_30) as OGTT_glucose_test_30,
       avg(OGTT_glucose_test_60) as OGTT_glucose_test_60,
       avg(OGTT_glucose_test_90) as OGTT_glucose_test_90,
       avg(OGTT_glucose_test_120) as OGTT_glucose_test_120,
       avg(OGTT_insulin_test_fasting) as OGTT_insulin_test_fasting,
       avg(OGTT_insulin_test_30) as OGTT_insulin_test_30,
       avg(OGTT_insulin_test_60) as OGTT_insulin_test_60,
       avg(OGTT_insulin_test_90) as OGTT_insulin_test_90,
       avg(OGTT_insulin_test_120) as OGTT_insulin_test_120,
       avg(OGTT_C_peptide_test_fasting) as OGTT_C_peptide_test_fasting,
       avg(OGTT_C_peptide_test_30) as OGTT_C_peptide_test_30,
       avg(OGTT_C_peptide_test_60) as OGTT_C_peptide_test_60,
       avg(OGTT_C_peptide_test_90) as OGTT_C_peptide_test_90,
       avg(OGTT_C_peptide_test_120) as OGTT_C_peptide_test_120,
       avg(glucose_with_breakfast_test_fasting) as glucose_with_breakfast_test_fasting,
       avg(glucose_with_breakfast_test_30) as glucose_with_breakfast_test_30,
       avg(glucose_with_breakfast_test_60) as glucose_with_breakfast_test_60,
       avg(glucose_with_breakfast_test_90) as glucose_with_breakfast_test_90,
       avg(glucose_with_breakfast_test_120) as glucose_with_breakfast_test_120,
       avg(insulin_with_breakfast_test_fasting) as insulin_with_breakfast_test_fasting,
       avg(insulin_with_breakfast_test_30) as insulin_with_breakfast_test_30,
       avg(insulin_with_breakfast_test_60) as insulin_with_breakfast_test_60,
       avg(insulin_with_breakfast_test_90) as insulin_with_breakfast_test_90,
       avg(insulin_with_breakfast_test_120) as insulin_with_breakfast_test_120,
       avg(c_peptide_with_breakfast_test_fasting) as c_peptide_with_breakfast_test_fasting,
       avg(c_peptide_with_breakfast_test_30) as c_peptide_with_breakfast_test_30,
       avg(c_peptide_with_breakfast_test_60) as c_peptide_with_breakfast_test_60,
       avg(c_peptide_with_breakfast_test_90) as c_peptide_with_breakfast_test_90,
       avg(c_peptide_with_breakfast_test_120) as c_peptide_with_breakfast_test_120,
       avg(IAA_to_insulin) as IAA_to_insulin,
       avg(ICA_to_pancreatic_beta_cells) as ICA_to_pancreatic_beta_cells,
       avg(GAD_glutamate_decarboxylase) as GAD_glutamate_decarboxylase,
       avg(IA2_to_tyrosine_phosphatase) as IA2_to_tyrosine_phosphatase,
       avg(ZnT8_to_zinc_transporter) as ZnT8_to_zinc_transporter
    from
        statistics.flat_cases d
    group by
        d.effective_diagnosis;


create view statistics.diagnosis__birth_weight
    as
select effective_diagnosis, birth_weight from statistics.flat_cases
    where birth_weight is not null order by effective_diagnosis;


create view statistics.diagnosis__glycated_hemoglobin_for_diagnosis_hba1c
    as
select effective_diagnosis, glycated_hemoglobin_for_diagnosis_hba1c from statistics.flat_cases
    where glycated_hemoglobin_for_diagnosis_hba1c is not null order by effective_diagnosis;


create view statistics.diagnosis__glucose_fasting_min
    as
select effective_diagnosis, glucose_fasting_min from statistics.flat_cases
    where glucose_fasting_min is not null order by effective_diagnosis;

create view statistics.diagnosis__glucose_fasting_max
    as
select effective_diagnosis, glucose_fasting_max from statistics.flat_cases
    where glucose_fasting_max is not null order by effective_diagnosis;


create view statistics.diagnosis__ogtt_insulin_test_fasting
    as
select effective_diagnosis, ogtt_insulin_test_fasting from statistics.flat_cases
    where ogtt_insulin_test_fasting is not null order by effective_diagnosis;

create view statistics.diagnosis__c_peptide_with_breakfast_test_fasting
    as
select effective_diagnosis, c_peptide_with_breakfast_test_fasting from statistics.flat_cases
    where c_peptide_with_breakfast_test_fasting is not null order by effective_diagnosis;

create view statistics.diagnosis__body_mass_index_sds
    as
select effective_diagnosis, body_mass_index_sds from statistics.flat_cases
    where body_mass_index_sds is not null order by effective_diagnosis;

create view statistics.diagnosis__glucose_with_breakfast_test_fasting
    as
select effective_diagnosis, glucose_with_breakfast_test_fasting from statistics.flat_cases
    where glucose_with_breakfast_test_fasting is not null order by effective_diagnosis;

create view statistics.diagnosis__iaa_to_insulin
    as
select effective_diagnosis, iaa_to_insulin from statistics.flat_cases
    where iaa_to_insulin is not null order by effective_diagnosis;

create view statistics.diagnosis__ica_to_pancreatic_beta_cells
    as
select effective_diagnosis, ica_to_pancreatic_beta_cells from statistics.flat_cases
    where ica_to_pancreatic_beta_cells is not null order by effective_diagnosis;

create view statistics.diagnosis__gad_glutamate_decarboxylase
    as
select effective_diagnosis, gad_glutamate_decarboxylase from statistics.flat_cases
    where gad_glutamate_decarboxylase is not null order by effective_diagnosis;

create view statistics.diagnosis__znt8_to_zinc_transporter
    as
select effective_diagnosis, znt8_to_zinc_transporter from statistics.flat_cases
    where znt8_to_zinc_transporter is not null order by effective_diagnosis;

