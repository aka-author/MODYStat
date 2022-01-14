

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


create or replace function statistics.numval(str varchar) returns numeric
    language plpgsql as $$
    begin
       return
            case
                when str ~ '(\s*)(\d+)((,\d*)?)(\s*)'
                    then to_number(str, '9999999D999999')
                end;
    end$$;


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
	HLA_gt_1_DRB1 									real,
	HLA_gt_1_DQA1 									real,
	HLA_gt_1_DQB1 									real,
	HLA_gt_2_DRB1 									real,
	HLA_gt_2_DQA1 									real,
	HLA_gt_2_DQB1 									real,
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
	HLA_gt_1_DRB1 									real,
	HLA_gt_1_DQA1 									real,
	HLA_gt_1_DQB1 									real,
	HLA_gt_2_DRB1 									real,
	HLA_gt_2_DQA1 									real,
	HLA_gt_2_DQB1 									real,
	notes_on_trees 									varchar,
	final_diagnosis 								varchar(255),
	memo1 											varchar,
	memo2 											varchar,
	gene 											varchar(255),
	mutation 										varchar(255)
);


create table statistics.source_observations_str (
	--uuid 											uuid default gen_random_uuid() primary key,
	case_no 										varchar,
	examination_no 									varchar,
	last_name 										varchar,
	first_name 										varchar,
	otchestvo 										varchar,
	sex 											varchar,
	date_of_birth 									varchar,
	age_when_examination_years 						varchar,
	age_when_examination_months 					varchar,
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