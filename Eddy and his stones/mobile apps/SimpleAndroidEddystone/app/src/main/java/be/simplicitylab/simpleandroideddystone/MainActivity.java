package be.simplicitylab.simpleandroideddystone;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import org.altbeacon.beacon.*;
import org.altbeacon.beacon.utils.UrlBeaconUrlCompressor;
import java.util.Collection;

public class MainActivity extends AppCompatActivity implements BeaconConsumer, RangeNotifier {

    private BeaconManager beaconManager;
    private String id;
    private String url;
    private double distance;
    private Button btnSearch;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnSearch  = (Button) findViewById(R.id.btnSearch);
        btnSearch.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // search for beacons
                searchBeacon();
            }
        });

    }

    /**
     * Search beacon
     */
    private void searchBeacon()
    {
        // init beacon manager
        beaconManager = BeaconManager.getInstanceForApplication(this.getApplicationContext());

        // Detect the Eddystone URL frame:
        beaconManager.getBeaconParsers().add(new BeaconParser().
                setBeaconLayout("s:0-1=feaa,m:2-2=10,p:3-3:-41,i:4-20v"));

        beaconManager.bind(this);
    }

    @Override
    public void onResume() {
        super.onResume();
    }



    @Override
    public void onPause() {
        super.onPause();
        beaconManager.unbind(this);
    }

    @Override
    public void onBeaconServiceConnect() {
        Region region = new Region("all-beacons-region", null, null, null);
        try {
            beaconManager.startRangingBeaconsInRegion(region);
        } catch (Exception e) {
            e.printStackTrace();
        }
        beaconManager.setRangeNotifier(this);
    }

    @Override
    public void didRangeBeaconsInRegion(Collection<Beacon> beacons, Region region) {
        for (Beacon beacon: beacons) {
            if (beacon.getServiceUuid() == 0xfeaa && beacon.getBeaconTypeCode() == 0x10) {

                // get id
                id = beacon.getBluetoothAddress();

                // update url
                url = UrlBeaconUrlCompressor.uncompress(beacon.getId1().toByteArray());

                // update string
                distance = beacon.getDistance();

                // update UI
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        // disable beacon button
                        btnSearch.setText("Beacon found");
                        btnSearch.setEnabled(false);


                        // update id
                        TextView txtId = (TextView) findViewById(R.id.txtID);
                        txtId.setText(id);

                        // update url textview
                        TextView txtUrl = (TextView) findViewById(R.id.txtUrl);
                        txtUrl.setText(url);

                        // update distance textview
                        TextView txtDistance = (TextView) findViewById(R.id.txtDistance);
                        txtDistance.setText((String.valueOf(distance)));
                    }
                });
            }
        }
    }

}
