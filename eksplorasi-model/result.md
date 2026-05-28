ARIMA
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">MAE</th>
      <th colspan="3" halign="left">RMSE</th>
      <th colspan="3" halign="left">MAPE (%)</th>
      <th colspan="3" halign="left">R2 Score</th>
    </tr>
    <tr>
      <th>Model</th>
      <th>ARIMA Murni</th>
      <th>Hybrid ARIMA + RF</th>
      <th>Random Forest Baseline</th>
      <th>ARIMA Murni</th>
      <th>Hybrid ARIMA + RF</th>
      <th>Random Forest Baseline</th>
      <th>ARIMA Murni</th>
      <th>Hybrid ARIMA + RF</th>
      <th>Random Forest Baseline</th>
      <th>ARIMA Murni</th>
      <th>Hybrid ARIMA + RF</th>
      <th>Random Forest Baseline</th>
    </tr>
    <tr>
      <th>Commodity</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bawang Merah</th>
      <td>220.5879</td>
      <td>246.3686</td>
      <td>313.7841</td>
      <td>424.5004</td>
      <td>440.6104</td>
      <td>497.7851</td>
      <td>0.4676</td>
      <td>0.5225</td>
      <td>0.6662</td>
      <td>0.9778</td>
      <td>0.9761</td>
      <td>0.9694</td>
    </tr>
    <tr>
      <th>Bawang Putih</th>
      <td>71.2921</td>
      <td>114.6228</td>
      <td>260.4011</td>
      <td>116.6954</td>
      <td>160.0852</td>
      <td>370.1858</td>
      <td>0.1789</td>
      <td>0.2872</td>
      <td>0.6558</td>
      <td>0.9633</td>
      <td>0.9310</td>
      <td>0.6311</td>
    </tr>
    <tr>
      <th>Beras</th>
      <td>16.3960</td>
      <td>42.8252</td>
      <td>26.9257</td>
      <td>58.5618</td>
      <td>67.3116</td>
      <td>57.5890</td>
      <td>0.1038</td>
      <td>0.2709</td>
      <td>0.1704</td>
      <td>0.5624</td>
      <td>0.4219</td>
      <td>0.5768</td>
    </tr>
    <tr>
      <th>Cabai Merah</th>
      <td>580.3972</td>
      <td>804.0821</td>
      <td>957.0448</td>
      <td>1048.3300</td>
      <td>1244.9391</td>
      <td>1346.8529</td>
      <td>1.1625</td>
      <td>1.6408</td>
      <td>1.9563</td>
      <td>0.9747</td>
      <td>0.9643</td>
      <td>0.9582</td>
    </tr>
    <tr>
      <th>Cabai Rawit</th>
      <td>741.4706</td>
      <td>812.6734</td>
      <td>1150.0773</td>
      <td>1284.8986</td>
      <td>1330.0965</td>
      <td>1634.4729</td>
      <td>1.1533</td>
      <td>1.2519</td>
      <td>1.7554</td>
      <td>0.9626</td>
      <td>0.9599</td>
      <td>0.9395</td>
    </tr>
    <tr>
      <th>Daging Ayam</th>
      <td>182.8260</td>
      <td>312.4596</td>
      <td>1345.8249</td>
      <td>401.4788</td>
      <td>473.7924</td>
      <td>1666.0137</td>
      <td>0.4476</td>
      <td>0.7603</td>
      <td>3.2169</td>
      <td>0.8963</td>
      <td>0.8556</td>
      <td>-0.7855</td>
    </tr>
    <tr>
      <th>Daging Sapi</th>
      <td>298.2703</td>
      <td>967.7511</td>
      <td>2681.7002</td>
      <td>1001.1561</td>
      <td>1417.3778</td>
      <td>3729.7112</td>
      <td>0.2104</td>
      <td>0.6768</td>
      <td>1.8593</td>
      <td>0.8746</td>
      <td>0.7487</td>
      <td>-0.7401</td>
    </tr>
    <tr>
      <th>Gula Pasir</th>
      <td>16.5605</td>
      <td>27.7226</td>
      <td>107.2751</td>
      <td>31.5263</td>
      <td>47.6077</td>
      <td>166.2597</td>
      <td>0.0857</td>
      <td>0.1446</td>
      <td>0.5502</td>
      <td>0.9885</td>
      <td>0.9737</td>
      <td>0.6790</td>
    </tr>
    <tr>
      <th>Minyak Goreng</th>
      <td>24.9114</td>
      <td>30.7707</td>
      <td>620.1571</td>
      <td>40.5345</td>
      <td>45.1395</td>
      <td>845.3053</td>
      <td>0.1132</td>
      <td>0.1407</td>
      <td>2.7981</td>
      <td>0.9952</td>
      <td>0.9941</td>
      <td>-1.0691</td>
    </tr>
    <tr>
      <th>Telur Ayam</th>
      <td>71.4187</td>
      <td>98.5745</td>
      <td>283.2062</td>
      <td>112.1555</td>
      <td>139.5414</td>
      <td>433.6685</td>
      <td>0.2225</td>
      <td>0.3055</td>
      <td>0.8613</td>
      <td>0.9807</td>
      <td>0.9701</td>
      <td>0.7111</td>
    </tr>
  </tbody>
</table>
</div>

XGBoost
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
      <th>Commodity</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Beras</th>
      <td>34.8461</td>
      <td>58.6133</td>
      <td>0.2200</td>
      <td>0.5480</td>
    </tr>
    <tr>
      <th>Daging Ayam</th>
      <td>2006.2859</td>
      <td>2314.5148</td>
      <td>4.8082</td>
      <td>-2.3525</td>
    </tr>
    <tr>
      <th>Daging Sapi</th>
      <td>3508.1733</td>
      <td>4557.4290</td>
      <td>2.4367</td>
      <td>-1.6841</td>
    </tr>
    <tr>
      <th>Telur Ayam</th>
      <td>300.2578</td>
      <td>436.8458</td>
      <td>0.9138</td>
      <td>0.7163</td>
    </tr>
    <tr>
      <th>Bawang Merah</th>
      <td>459.4033</td>
      <td>594.9403</td>
      <td>0.9794</td>
      <td>0.9572</td>
    </tr>
    <tr>
      <th>Bawang Putih</th>
      <td>556.6170</td>
      <td>760.4258</td>
      <td>1.4071</td>
      <td>-0.5378</td>
    </tr>
    <tr>
      <th>Cabai Merah</th>
      <td>856.6122</td>
      <td>1227.0364</td>
      <td>1.7399</td>
      <td>0.9590</td>
    </tr>
    <tr>
      <th>Cabai Rawit</th>
      <td>1040.1810</td>
      <td>1412.0949</td>
      <td>1.5860</td>
      <td>0.9562</td>
    </tr>
    <tr>
      <th>Minyak Goreng</th>
      <td>671.0543</td>
      <td>879.5617</td>
      <td>3.0314</td>
      <td>-1.2422</td>
    </tr>
    <tr>
      <th>Gula Pasir</th>
      <td>111.2208</td>
      <td>165.8233</td>
      <td>0.5710</td>
      <td>0.6765</td>
    </tr>
  </tbody>
</table>
</div>

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
      <th>Commodity</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Beras</th>
      <td>262.1556</td>
      <td>332.0804</td>
      <td>1.6547</td>
      <td>-13.0713</td>
    </tr>
    <tr>
      <th>Daging Ayam</th>
      <td>1317.2906</td>
      <td>1713.7438</td>
      <td>3.2770</td>
      <td>-0.8893</td>
    </tr>
    <tr>
      <th>Daging Sapi</th>
      <td>2511.6497</td>
      <td>2986.6089</td>
      <td>1.7530</td>
      <td>-0.1158</td>
    </tr>
    <tr>
      <th>Telur Ayam</th>
      <td>5782.4768</td>
      <td>6328.7969</td>
      <td>17.9992</td>
      <td>-60.5210</td>
    </tr>
    <tr>
      <th>Bawang Merah</th>
      <td>7871.9371</td>
      <td>9363.3083</td>
      <td>17.1372</td>
      <td>-9.8126</td>
    </tr>
    <tr>
      <th>Bawang Putih</th>
      <td>3129.0169</td>
      <td>3389.1651</td>
      <td>7.7746</td>
      <td>-29.9211</td>
    </tr>
    <tr>
      <th>Cabai Merah</th>
      <td>57041.7480</td>
      <td>60629.9966</td>
      <td>122.0845</td>
      <td>-83.7839</td>
    </tr>
    <tr>
      <th>Cabai Rawit</th>
      <td>11532.8929</td>
      <td>14351.5627</td>
      <td>17.2522</td>
      <td>-3.6652</td>
    </tr>
    <tr>
      <th>Minyak Goreng</th>
      <td>722.4225</td>
      <td>938.1244</td>
      <td>3.2683</td>
      <td>-1.5485</td>
    </tr>
    <tr>
      <th>Gula Pasir</th>
      <td>87.4716</td>
      <td>110.6743</td>
      <td>0.4536</td>
      <td>0.8578</td>
    </tr>
  </tbody>
</table>
</div>