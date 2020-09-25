sdnaprepare.py --im net=join_drape_proj_hwclasses --om net=join_drape_proj_hwclasses_p action=repair;xytol=0.5;nearmisses;isolated;data_text=highway;data_absolute=aadt,roadclass

sdnaintegral.py --im net=join_drape_proj_hwclasses_p --om net=integral.shp metric=cycle_roundtrip;radii=10000