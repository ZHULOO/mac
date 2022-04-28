library("readxl")
ex2<-"E:/Codelearning/fastSOM/dy_ej2009.xls"#需要导入的xls文件路径
read_excel(ex2)#读取xls和xlsx格式数据，探索数据格式
excel_sheets(ex2)#列出所有sheet的名称
read_excel(ex2,sheet = "weekly_rangevol")#读数据文件中名称为weekly_rangevolsheet
#的文件，或者sheet=1,第一张sheet中的数据
read_excel(ex2, sheet=2,n_max = 3)#读取第二张sheet的前三行数据
read_excel(ex2, sheet=2,range = "a1:c3")#读取第二张sheet的a1:c3单元格数据
read_excel(ex2, sheet=2,range = cell_rows(2:4))#读取第二张sheet的第2到4行数据
read_excel(ex2, sheet=2,range = cell_cols("B:D"))#读取第二张sheet的第2到4列数据
read_excel(ex2, range = "weekly_rangevol!B1:D5")#读取名称weekly_rangevol sheet中的B1:D5数据



