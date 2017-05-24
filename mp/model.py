from modeller import *
from modeller.automodel import *

env = environ()
env.io.hetatm = True
a = automodel(env, alnfile='mp_1jgg.pir',
              knowns='1jgg', sequence='mp',
              assess_methods=(assess.DOPE,
                              assess.GA341))
a.starting_model = 1
a.ending_model = 5
a.make()
