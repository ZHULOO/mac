from win32com.client import gencache
from win32com.client import constants, gencache
import os,re
def createPdf(wordPath, pdfPath):
  """
  word转pdf
  :param wordPath: word文件路径
  :param pdfPath: 生成pdf文件路径
  """
  word = gencache.EnsureDispatch('Word.Application')
  doc = word.Documents.Open(wordPath, ReadOnly=1)
  doc.ExportAsFixedFormat(pdfPath,
              constants.wdExportFormatPDF,
              Item=constants.wdExportDocumentWithMarkup,
              CreateBookmarks=constants.wdExportCreateHeadingBookmarks)
  word.Quit(constants.wdDoNotSaveChanges)
###批量转换-----os.getcwd()可以替换你自己的目录比如d:\docs\
for dirs,subdirs,files in os.walk(os.getcwd()):
    for name in files:
        if re.search(r'\.(doc|docx)', name):
            print(dirs,subdirs,name)
            if subdirs:
              createPdf(dirs+subdirs+name,re.subn(r'(doc|docx)', 'pdf', name))
            else:
               createPdf(dirs+'\\'+name,dirs+'\\'+re.subn(r'(doc|docx)', 'pdf', name)[0])
        print('--------------文档已全部转换完成-----------------------')




import os
os.chdir("e:\\word")
os.getcwd()

for dirs,subdirs,files in os.walk(os.getcwd()):
    print(dirs)
    print(subdirs)
    print(files)

