#########3
from faker import Faker
import mappings as k
import pandas as pd
import re
import random
from collections import OrderedDict

dummy = Faker()
feesamt = 9
default_tld = ".com"
barrels = 10
def fees():
    fees = {
        "region":[dummy.unique.random_element(elements=('Caribbean','Europe','Latin America','North Atlantic','Arctic Ocean','Eurasia','North America','Atlantic Ocean','Mediterranean Sea')) for _ in range(feesamt)],
        "taxes":[dummy.random_int(min=3, max=25) for _ in range(feesamt)],
        "levies":[dummy.random_int(min=3, max=45) for _ in range(feesamt)],
        "fees":[dummy.random_int(min=3, max=15) for _ in range(feesamt)],
        "hazard_fee":[dummy.random_int(min=100, max=300) for _ in range(feesamt)]
    }
    fees_df = pd.DataFrame(fees)
    fees_df.to_csv("shipping_fees.csv", index=False)
    
def barrel():
    fees = {
        "barrelcode":[dummy.unique.random_number(digits=3) for _ in range(barrels)],
        "region":[dummy.unique.random_element(elements=('IBC Tote',
                                                        'Steel Drum Tight-head',
                                                        'Steel Drum Open-head',
                                                        'Plastic Drum Open-head',
                                                        'Plastic Drum Closed-head',
                                                        'Fiber Drums Open-head',
                                                        'Steel Pail Open-head',
                                                        'Steel Pail Closed-head',
                                                        'Plastic Pail Screw Top',
                                                        'Plastic Pail Snap Top',)) for _ in range(barrels)],

    }
    fees_df = pd.DataFrame(fees)
    fees_df.to_csv("shipping_biz.csv", index=False)



if __name__== '__main__':
    barrel()