KNN
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>MAE</th>
      <th>RMSE</th>
      <th>MAPE (%)</th>
      <th>R2 Score</th>
    </tr>
    <tr>
      <th>Subcategory</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bawang Merah Ukuran Sedang</th>
      <td>1616.7710</td>
      <td>2295.2543</td>
      <td>3.3118</td>
      <td>0.3539</td>
    </tr>
    <tr>
      <th>Bawang Putih Ukuran Sedang</th>
      <td>750.7146</td>
      <td>863.4865</td>
      <td>1.8860</td>
      <td>-1.0043</td>
    </tr>
    <tr>
      <th>Beras Kualitas Bawah I</th>
      <td>70.9935</td>
      <td>107.2959</td>
      <td>0.4935</td>
      <td>-0.4229</td>
    </tr>
    <tr>
      <th>Beras Kualitas Bawah II</th>
      <td>44.3478</td>
      <td>55.5177</td>
      <td>0.3060</td>
      <td>0.5168</td>
    </tr>
    <tr>
      <th>Beras Kualitas Medium I</th>
      <td>55.3064</td>
      <td>75.8006</td>
      <td>0.3460</td>
      <td>0.3004</td>
    </tr>
    <tr>
      <th>Beras Kualitas Medium II</th>
      <td>84.2285</td>
      <td>116.6817</td>
      <td>0.5318</td>
      <td>-0.1561</td>
    </tr>
    <tr>
      <th>Beras Kualitas Super I</th>
      <td>66.0921</td>
      <td>103.2839</td>
      <td>0.3851</td>
      <td>0.2937</td>
    </tr>
    <tr>
      <th>Beras Kualitas Super II</th>
      <td>72.3961</td>
      <td>110.0336</td>
      <td>0.4319</td>
      <td>0.1502</td>
    </tr>
    <tr>
      <th>Cabai Merah Besar</th>
      <td>3988.4990</td>
      <td>5253.5000</td>
      <td>8.9080</td>
      <td>0.1899</td>
    </tr>
    <tr>
      <th>Cabai Merah Keriting</th>
      <td>4550.2392</td>
      <td>5447.5953</td>
      <td>9.7708</td>
      <td>0.3454</td>
    </tr>
    <tr>
      <th>Cabai Rawit Hijau</th>
      <td>2354.1438</td>
      <td>3160.5644</td>
      <td>4.2254</td>
      <td>0.5259</td>
    </tr>
    <tr>
      <th>Cabai Rawit Merah</th>
      <td>4058.0859</td>
      <td>4939.2960</td>
      <td>5.5093</td>
      <td>0.7764</td>
    </tr>
    <tr>
      <th>Daging Ayam Ras Segar</th>
      <td>1787.6530</td>
      <td>2087.2262</td>
      <td>4.2892</td>
      <td>-1.7911</td>
    </tr>
    <tr>
      <th>Daging Sapi Kualitas 1</th>
      <td>2791.0424</td>
      <td>3748.5235</td>
      <td>1.8941</td>
      <td>-0.7050</td>
    </tr>
    <tr>
      <th>Daging Sapi Kualitas 2</th>
      <td>3000.1373</td>
      <td>3869.7089</td>
      <td>2.1592</td>
      <td>-1.1412</td>
    </tr>
    <tr>
      <th>Gula Pasir Kualitas Premium</th>
      <td>147.0751</td>
      <td>188.9633</td>
      <td>0.7326</td>
      <td>-0.2353</td>
    </tr>
    <tr>
      <th>Gula Pasir Lokal</th>
      <td>171.1425</td>
      <td>223.0902</td>
      <td>0.9069</td>
      <td>0.6928</td>
    </tr>
    <tr>
      <th>Minyak Goreng Curah</th>
      <td>690.9402</td>
      <td>948.8027</td>
      <td>3.4423</td>
      <td>-0.8137</td>
    </tr>
    <tr>
      <th>Minyak Goreng Kemasan Bermerk 1</th>
      <td>600.4967</td>
      <td>780.0288</td>
      <td>2.5710</td>
      <td>-1.2847</td>
    </tr>
    <tr>
      <th>Minyak Goreng Kemasan Bermerk 2</th>
      <td>585.3407</td>
      <td>800.7536</td>
      <td>2.6075</td>
      <td>-1.1393</td>
    </tr>
    <tr>
      <th>Telur Ayam Ras Segar</th>
      <td>531.4663</td>
      <td>697.4448</td>
      <td>1.6209</td>
      <td>0.2571</td>
    </tr>
  </tbody>
</table>
</div>

LSTM
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>MAE</th>
      <th>RMSE</th>
      <th>MAPE (%)</th>
      <th>R2 Score</th>
    </tr>
    <tr>
      <th>Subcategory</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bawang Merah Ukuran Sedang</th>
      <td>589.7870</td>
      <td>750.7886</td>
      <td>1.2523</td>
      <td>0.9312</td>
    </tr>
    <tr>
      <th>Bawang Putih Ukuran Sedang</th>
      <td>511.7843</td>
      <td>592.6195</td>
      <td>1.2837</td>
      <td>0.0730</td>
    </tr>
    <tr>
      <th>Beras Kualitas Bawah I</th>
      <td>46.9926</td>
      <td>89.8761</td>
      <td>0.3265</td>
      <td>0.0004</td>
    </tr>
    <tr>
      <th>Beras Kualitas Bawah II</th>
      <td>24.2306</td>
      <td>33.3154</td>
      <td>0.1674</td>
      <td>0.7992</td>
    </tr>
    <tr>
      <th>Beras Kualitas Medium I</th>
      <td>48.3567</td>
      <td>75.1489</td>
      <td>0.3030</td>
      <td>0.2916</td>
    </tr>
    <tr>
      <th>Beras Kualitas Medium II</th>
      <td>65.7560</td>
      <td>109.2292</td>
      <td>0.4172</td>
      <td>-0.0162</td>
    </tr>
    <tr>
      <th>Beras Kualitas Super I</th>
      <td>48.9055</td>
      <td>106.4436</td>
      <td>0.2860</td>
      <td>0.2455</td>
    </tr>
    <tr>
      <th>Beras Kualitas Super II</th>
      <td>114.1962</td>
      <td>148.4437</td>
      <td>0.6813</td>
      <td>-0.5499</td>
    </tr>
    <tr>
      <th>Cabai Merah Besar</th>
      <td>2871.0975</td>
      <td>3539.1151</td>
      <td>6.1256</td>
      <td>0.5975</td>
    </tr>
    <tr>
      <th>Cabai Merah Keriting</th>
      <td>2215.6604</td>
      <td>2789.6338</td>
      <td>4.5916</td>
      <td>0.7936</td>
    </tr>
    <tr>
      <th>Cabai Rawit Hijau</th>
      <td>2185.5407</td>
      <td>2989.0820</td>
      <td>3.8768</td>
      <td>0.5917</td>
    </tr>
    <tr>
      <th>Cabai Rawit Merah</th>
      <td>2858.5548</td>
      <td>3681.8240</td>
      <td>3.9170</td>
      <td>0.8803</td>
    </tr>
    <tr>
      <th>Daging Ayam Ras Segar</th>
      <td>567.1635</td>
      <td>789.5158</td>
      <td>1.3677</td>
      <td>0.6142</td>
    </tr>
    <tr>
      <th>Daging Sapi Kualitas 1</th>
      <td>1611.1711</td>
      <td>1950.4308</td>
      <td>1.1000</td>
      <td>0.5202</td>
    </tr>
    <tr>
      <th>Daging Sapi Kualitas 2</th>
      <td>1282.0844</td>
      <td>1657.8062</td>
      <td>0.9246</td>
      <td>0.5840</td>
    </tr>
    <tr>
      <th>Gula Pasir Kualitas Premium</th>
      <td>73.5901</td>
      <td>83.5413</td>
      <td>0.3688</td>
      <td>0.7594</td>
    </tr>
    <tr>
      <th>Gula Pasir Lokal</th>
      <td>67.4257</td>
      <td>80.3696</td>
      <td>0.3597</td>
      <td>0.9590</td>
    </tr>
    <tr>
      <th>Minyak Goreng Curah</th>
      <td>372.8365</td>
      <td>517.0981</td>
      <td>1.8547</td>
      <td>0.4609</td>
    </tr>
    <tr>
      <th>Minyak Goreng Kemasan Bermerk 1</th>
      <td>285.9448</td>
      <td>400.8873</td>
      <td>1.2190</td>
      <td>0.3974</td>
    </tr>
    <tr>
      <th>Minyak Goreng Kemasan Bermerk 2</th>
      <td>274.9271</td>
      <td>391.1783</td>
      <td>1.2211</td>
      <td>0.4921</td>
    </tr>
    <tr>
      <th>Telur Ayam Ras Segar</th>
      <td>464.7026</td>
      <td>553.1752</td>
      <td>1.4251</td>
      <td>0.5502</td>
    </tr>
  </tbody>
</table>
</div>
