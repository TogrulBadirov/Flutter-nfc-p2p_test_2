// package io.flutter.plugins.nfc_p2p_demo;

// import android.app.Activity;
// import android.nfc.NdefMessage;
// import android.nfc.NdefRecord;
// import android.nfc.NfcAdapter;
// import android.nfc.NfcEvent;
// import android.os.Bundle;
// import android.util.Log;
// import android.widget.Toast;



// import androidx.annotation.NonNull;

// import java.nio.charset.StandardCharsets;

// import io.flutter.embedding.android.FlutterActivity;
// import io.flutter.embedding.engine.FlutterEngine;
// import io.flutter.plugin.common.MethodCall;
// import io.flutter.plugin.common.MethodChannel;

// public class NfcP2PHandler extends FlutterActivity implements NfcAdapter.CreateNdefMessageCallback {
//     private static final String CHANNEL = "nfc_p2p_channel";
//     private static final String TAG = "NfcP2PHandler";

//     private NfcAdapter nfcAdapter;
//     private String messageToSend;

//     @Override
//     public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//         super.configureFlutterEngine(flutterEngine);
//         new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
//                 (call, result) -> {
//                     if (call.method.equals("sendNfcMessage")) {
//                         messageToSend = call.argument("message");
//                         result.success(null);
//                     } else {
//                         result.notImplemented();
//                     }
//                 }
//         );
//     }

//     @Override
//     protected void onCreate(Bundle savedInstanceState) {
//         super.onCreate(savedInstanceState);
//         nfcAdapter = NfcAdapter.getDefaultAdapter(this);
//         if (nfcAdapter != null) {
//             nfcAdapter.setNdefPushMessageCallback(this, this);
//         }
//     }

//     @Override
//     public NdefMessage createNdefMessage(NfcEvent event) {
//         if (messageToSend != null && !messageToSend.isEmpty()) {
//             byte[] messageBytes = messageToSend.getBytes(StandardCharsets.UTF_8);
//             NdefRecord mimeRecord = NdefRecord.createMime("text/plain", messageBytes);
//             NdefMessage ndefMessage = new NdefMessage(new NdefRecord[]{ mimeRecord });

//             Log.d(TAG, "Sending NFC message: " + messageToSend);
//             Toast.makeText(this, "Sending NFC message: " + messageToSend, Toast.LENGTH_SHORT).show();
//             return ndefMessage;
//         }
//         return null;
//     }
// }
