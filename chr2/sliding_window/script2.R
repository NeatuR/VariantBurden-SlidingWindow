library(stringr)
library(readr)

args <- commandArgs(trailingOnly = TRUE)
index=as.numeric(args[1])

c=index


test <- read.delim("controls_chr3_final2.tsv", header = FALSE, sep = " ")
test[is.na(test)] <- 0


output <- numeric(0)
row_position = 1
#slide
skip_rows = 250
#window
count_rows = 500

end_of_file = length(test[,c])
terminal_output_time = 5000
terminal_output_tracker = 0
#end_of_file = 4
for (i in 1:end_of_file) {
  if(i == row_position) {
    final_sum = test[i,c]
    temp_count = 1
    #while (temp_count != count_rows || final_sum + test[i+temp_count,c] > end_of_file) {
    while (temp_count != count_rows && is.na(test[i+temp_count,c]) == FALSE) {
print(final_sum)
      if(final_sum < 1){
	final_sum = final_sum + test[i+temp_count,c]
      }
      temp_count = temp_count + 1
    }

print(final_sum)
    
    if (final_sum > 0) {
      final_sum = 1
    }


    output <- append(output, final_sum)
    
   #print(output)
    
    if(i >= terminal_output_tracker) {
      print('Still going, past:')
      print(terminal_output_tracker)
      terminal_output_tracker = terminal_output_tracker + terminal_output_time
    }
    
    if(row_position + skip_rows <= end_of_file) {
      row_position = row_position + skip_rows
    }
  }
}


write.csv(output, file=paste("cons_",c,sep=","), row.names = FALSE)
