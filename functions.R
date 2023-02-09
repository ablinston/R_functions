library(data.table)
library(dplyr)
library(knitr)

compare_data <- function(data_1, data_2, sort, precision = 1000) {
  
  data1 = as.data.table(copy(data_1))
  data2 = as.data.table(copy(data_2))
  
  if (precision <= 100) {
  
    for (col in colnames(data1)) {
      if (is.numeric(data1[, get(col)])) {
        data1[, (col) := round(get(col), precision)]
      }
    }
    
    for (col in colnames(data2)) {
      if (is.numeric(data2[, get(col)])) {
        data2[, (col) := round(get(col), precision)]
      }
    }
    
  }

  if (identical(data1, data2)) {
    
    print("Datasets identical")
    
  } else {
    
    if (nrow(data1)  == nrow(data2)) {
      print("Match: Row numbers")
    } else {
      print("No match: Row numbers")
    }
    
    if (length(colnames(data1)) == length(colnames(data2)) &&
        all(colnames(data1) == colnames(data2))) {
      print("Match: All columns")
    } else {
      print("No match: Columns")
      print(paste0("Not in first: ", setdiff(colnames(data2), colnames(data1)) %>% toString))
      print(paste0("Not in second: ", setdiff(colnames(data1), colnames(data2)) %>% toString))
    }
    
    if (sort == TRUE) {
      if ("loan_id" %in% colnames(data1)) {
        data1f <- data1 %>% arrange(loan_id) %>% as.data.frame
        data2f <- data2 %>% arrange(loan_id) %>% as.data.frame
      } else if ("x_master_ano_id" %in% colnames(data1)) {
        data1f <- data1 %>% arrange(x_master_ano_id) %>% as.data.frame
        data2f <- data2 %>% arrange(x_master_ano_id) %>% as.data.frame
      } else {
        data1f <- data1 %>% as.data.frame
        data2f <- data2 %>% as.data.frame
      }
    } else {
      data1f <- data1 %>% as.data.frame
      data2f <- data2 %>% as.data.frame
    }
    
    for (columni in colnames(data1f)) {
      if (columni %in% colnames(data2f)) {
        if (is.numeric(data1f[, columni])) {
          if (identical(data2f[, columni], data1f[, columni])) {
            print(paste0("Match: ", columni))
          } else {
            print(paste0("No match: ", columni))
            print(paste("Total difference:", sprintf("%.100f",
              abs(data2f %>% pull(columni) %>% sum(na.rm = TRUE)) - 
                abs(data1f %>% pull(columni) %>% sum(na.rm = TRUE)))))
            data1f %>% pull(columni) %>% summary() %>% print()
            data2f %>% pull(columni) %>% summary() %>% print()
          }
        } else {
          if (identical(data2f[, columni], data1f[, columni])) {
            # print(paste0("Match: ", columni))
          } else {
            print(paste0("No match: ", columni))
            data1f %>% pull(columni) %>% summary()
            data2f %>% pull(columni) %>% summary()
          }
        }
      } else {
        # print(paste0(columni, " not in both datasets"))
      }
    }
  }
  print("Check complete")
}




size_of_list <- function(list_object) {
  
  items <- data.frame(name = names(list_object),
                      size = NA)
  
  for (i in c(1:length(list_object))) {
    
    items[i, "size"] <- object.size(list_object[[i]])
    
  }
  
  print(items %>% arrange(size))
  
}

compare_dataset_list = function(list1, list2, sort = FALSE, precision = 10) {
  
  if (length(list1) != length(list2)) {
    stop("List lengths don't match")
  }
  

  
  for (i in c(1:length(list1))) {
    
    setnames(list1[[i]],
             names(list1[[i]])[grepl("ADJUSTED_EC", names(list1[[i]]))],
             gsub("_ADJUSTED_EC",
                  "_1415",
                  names(list1[[i]])[grepl("ADJUSTED_EC", names(list1[[i]]))]))
    
    setnames(list2[[i]],
             names(list2[[i]])[grepl("ADJUSTED_EC", names(list2[[i]]))],
             gsub("_ADJUSTED_EC",
                  "_1415",
                  names(list2[[i]])[grepl("ADJUSTED_EC", names(list2[[i]]))]))
    compare_data(list1[[i]], list2[[i]], sort = sort, precision = precision)
  }
  
}



