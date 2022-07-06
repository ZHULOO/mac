'''
conda activate geo
conda install python-docx
conda install docxcompose
'''
import os
from docx import Document
from docxcompose.composer import Composer

original_docx_path='/Users/zhulu/Desktop/教学设计/'
original='/Users/zhulu/Desktop/教学设计/1.docx'
new_docx_path='/Users/zhulu/Desktop/合并/hebing.docx'

# all_word=os.listdir(original_docx_path)
all_file_path=[]
for i in range(2,21):
    all_file_path.append(original_docx_path+"{0}.docx".format(i))
master=Document(original)
middle_new_docx=Composer(master)
for word in all_file_path:
    word_document=Document(word)
    word_document.add_page_break()
    middle_new_docx.append(word_document)
middle_new_docx.save(new_docx_path)

