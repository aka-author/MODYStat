
# Loading data

#essential_cases <- read.table("C:/privat/misha/mody/work/ec2022-05-15.csv", header=TRUE, sep=",", encoding="UTF-8")
#essential_cases <- read.table("C:/privat/misha/mody/work/Assessing_initial_observations.csv", header=TRUE, sep=",", encoding="UTF-8")

essential_cases <- read.table("C:/privat/misha/mody/work/flat-2022-08-13.csv", header=TRUE, sep=",", encoding="UTF-8")

# write.table(essential_cases)

# Здоров
print("Здоров")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='Здоров'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='Здоров'),])


# SD1
print("СД1")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='СД1'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='СД1'),])


# SD2
print("СД2")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='СД2'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='СД2'),])


# MODY2
print("MODY2")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='MODY2'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='MODY2'),])


# MODY3
print("MODY3")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='MODY3'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='MODY3'),])


# MODY др.
print("MODY др.")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='MODY др.'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='MODY др.'),])


# DIDMOAD
print("DIDMOAD")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='DIDMOAD'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='DIDMOAD'),])


# ДИГ
print("ДИГ")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='ДИГ'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='ДИГ'),])


# Альстрем
print("Альстрем")
print(nrow(essential_cases[which(essential_cases$effective_diagnosis=='Альстрем'),]))
summary(essential_cases[which(essential_cases$effective_diagnosis=='Альстрем'),])


# Any SD
print("Any SD (non-MODY)")
print(cat("Number of records:", nrow(essential_cases[which(
		essential_cases$effective_diagnosis=='СД1' |
		essential_cases$effective_diagnosis=='СД2' |
		essential_cases$effective_diagnosis=='СД неут.' |
		essential_cases$effective_diagnosis=='ДГМ'),])))
		
summary(essential_cases[which(
		essential_cases$effective_diagnosis=='СД1' |
		essential_cases$effective_diagnosis=='СД2' |
		essential_cases$effective_diagnosis=='СД неут.' |
		essential_cases$effective_diagnosis=='ДГМ'),])


# Any MODY
print("Any MODY")

print("Number of records:")
print(nrow(essential_cases[which(
		essential_cases$effective_diagnosis=='MODY2' |
		essential_cases$effective_diagnosis=='MODY3' |
		essential_cases$effective_diagnosis=='MODY др.'),]))

summary(essential_cases[which(
		essential_cases$effective_diagnosis=='MODY2' |
		essential_cases$effective_diagnosis=='MODY3' |
		essential_cases$effective_diagnosis=='MODY др.'),])


