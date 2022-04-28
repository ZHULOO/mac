import tushare as ts
ts.set_token('984b679dde56596c1a16ce747644f5bde7b09be27c934fb23fe15ff5')
pro = ts.pro_api()
df = ts.get_deposit_rate()
df
type(df)