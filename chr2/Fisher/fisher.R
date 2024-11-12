library(readr)

print('Rscript starts')

chr <- read.delim("counts_wind50.txt", header = FALSE, sep=" ")

print('the table is in')

names(chr) <- c("wind","af","con","total_af","total_con","diff_af","diff_con")

mat = matrix(ncol = 0, nrow = 0)
final = data.frame(mat)

print('the variables have been assigned')
#####
for (i in 1:nrow(chr)) {

row <- chr[i,]

row_select <- row[, c('af', 'con', 'diff_af', 'diff_con')]

matrix <- matrix(unlist(row_select),nrow=2,ncol=2,byrow=TRUE)

results <- fisher.test(matrix)
p <- results$p.value

final <- append(final, p)

}
####

print('the loop ended')

write.csv(final, "chr3_50bp_p.csv")

print('the table has been created')
