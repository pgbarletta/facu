from modeller import *

env = environ()
aln = alignment(env)
mdl = model(env, file='1jgg', model_segment=('FIRST:A','LAST:A'))
aln.append_model(mdl, align_codes='1jgg', atom_files='1jgg.pdb')
aln.append(file='mp.pir', align_codes='mp')
aln.align2d()
aln.write(file='mp_1jgg.pir', alignment_format='PIR')
aln.write(file='mp_1jgg.pap', alignment_format='PAP')
