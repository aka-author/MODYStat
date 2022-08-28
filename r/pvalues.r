
library(dplyr)

options(width=120)

varNames <-list(
	"c_peptide_with_test_fasting",	
	"body_mass_index_sds",	
	"glucose_fasting_min",	
	"glucose_fasting_max",	
	"ogtt_glucose_test_fasting",	
	"ogtt_insulin_test_fasting",
	"glucose_with_breakfast_test_fasting",	
	"insulin_with_breakfast_test_fasting",
	"iaa_to_insulin",
	"ica_to_pancreatic_beta_cells",
	"gad_glutamate_decarboxylase",
	"ia2_to_tyrosine_phosphatase")	

diagNames <- c("DIDMOAD", "MODY2", "MODY3", "MODYX", "MODY др.", "Альстрем", "СД1", "СД2", "СД неут.")

nDiags <- length(diagNames)

pVals <- array(,,dim=c(nDiags, nDiags))

colnames(pVals) <- diagNames
rownames(pVals) <- diagNames

cases <- read.table("C:/privat/misha/mody/work/flat_cases-2022-08-28.csv", header=TRUE, sep=",", encoding="UTF-8")

#for(varName in varNames) {

	#for(vv in 1:(nDiags-1)) {
	#	for(vh in (vv+1):nDiags) {		
	#		subset <- data.frame(cases[which(
	#				cases$effective_diagnosis==diagNames[vv] |
	#				cases$effective_diagnosis==diagNames[vh] ),])
	#		#pVals[vv, vh]  <- wilcox.test(glycated_hemoglobin_for_diagnosis_hba1c~effective_diagnosis, 
	#		#							data=subset)$p.value
	#		pVals[vv, vh]  <- wilcox.test(rlang::sym(varName)~effective_diagnosis, 
	#									data=subset)$p.value
	#		
	#	}
	# }

	#print(noquote(""))
	#print(noquote(""))
	#print(noquote(varName))
	#print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))	
#}


for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(glycated_hemoglobin_for_diagnosis_hba1c~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("glycated_hemoglobin_for_diagnosis_hba1c"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))	


for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(c_peptide_with_test_fasting~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("c_peptide_with_test_fasting"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))


for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(body_mass_index_sds~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("body_mass_index_sds"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))	


# glucose_fasting_min

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(glucose_fasting_min~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("glucose_fasting_min"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))	

# glucose_fasting_max

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(glucose_fasting_max~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("glucose_fasting_max"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# ogtt_glucose_test_fasting

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(ogtt_glucose_test_fasting~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("ogtt_glucose_test_fasting"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# ogtt_insulin_test_fasting

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(ogtt_insulin_test_fasting~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("ogtt_insulin_test_fasting"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# glucose_with_breakfast_test_fasting

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh] ),])
		pVals[vv, vh]  <- wilcox.test(glucose_with_breakfast_test_fasting~effective_diagnosis, 
										data=subset)$p.value
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("glucose_with_breakfast_test_fasting"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))


# insulin_with_breakfast_test_fasting

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				(cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh]) & 
				!is.na(cases$insulin_with_breakfast_test_fasting) ),])
		
		if(n_distinct(subset$effective_diagnosis) == 2) {
			pVals[vv, vh]  <- wilcox.test(insulin_with_breakfast_test_fasting~effective_diagnosis, 
											data=subset)$p.value
		} else {
			pVals[vv, vh] <- NA
		}	
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("insulin_with_breakfast_test_fasting"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# iaa_to_insulin

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				(cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh]) & 
				!is.na(cases$iaa_to_insulin) ),])
		if(n_distinct(subset$effective_diagnosis) == 2) {		
			pVals[vv, vh]  <- wilcox.test(iaa_to_insulin~effective_diagnosis, 
											data=subset)$p.value
		} else {
			pVals[vv, vh] = NA
		}
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("iaa_to_insulin"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# ica_to_pancreatic_beta_cells

 for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				(cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh]) & 
				!is.na(cases$ica_to_pancreatic_beta_cells) ),])
		if(n_distinct(subset$effective_diagnosis) == 2) {
			pVals[vv, vh]  <- wilcox.test(ica_to_pancreatic_beta_cells~effective_diagnosis, 
										data=subset)$p.value
		} else {
			pVals[vv, vh] = NA
		}
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("ica_to_pancreatic_beta_cells"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# gad_glutamate_decarboxylase

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				(cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh]) & 
				!is.na(cases$ica_to_pancreatic_beta_cells)),])
		if(n_distinct(subset$effective_diagnosis) == 2) {		
			pVals[vv, vh]  <- wilcox.test(gad_glutamate_decarboxylase~effective_diagnosis, 
										data=subset)$p.value
		} else {
			pVals[vv, vh] = NA
		}
			
	}
}

print(noquote(""))
print(noquote(""))
print(noquote("gad_glutamate_decarboxylase"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# ia2_to_tyrosine_phosphatase

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				(cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh]) & 
				!is.na(cases$ica_to_pancreatic_beta_cells)),])
		if(n_distinct(subset$effective_diagnosis) == 2) {
			pVals[vv, vh]  <- wilcox.test(ia2_to_tyrosine_phosphatase~effective_diagnosis, 
											data=subset)$p.value
		} else {
			pVals[vv, vh] = NA
		}
			
	}
}

print(noquote(format("")))
print(noquote(format("")))
print(noquote("ia2_to_tyrosine_phosphatase"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))

# znt8_to_zinc_transporter

for(vv in 1:(nDiags-1)) {
	for(vh in (vv+1):nDiags) {		
		subset <- data.frame(cases[which(
				(cases$effective_diagnosis==diagNames[vv] |
				cases$effective_diagnosis==diagNames[vh]) & 
				!is.na(cases$ica_to_pancreatic_beta_cells) ),])
		
		if(n_distinct(subset$effective_diagnosis)==2) {		
			pVals[vv, vh]  <- tryCatch(wilcox.test(znt8_to_zinc_transporter~effective_diagnosis, 
										data=subset)$p.value)
		} else {
			pVals[vv, vh] = NA
		}
			
	}
}

print(noquote(format("")))
print(noquote(format("")))
print(noquote("znt8_to_zinc_transporter"))
print(noquote(""))
print(noquote(format(round(pVals,6),digits=8,nsmall=6,scientific=FALSE)))
