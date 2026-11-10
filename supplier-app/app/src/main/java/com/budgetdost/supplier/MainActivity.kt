package com.budgetdost.supplier
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { SupplierScreen() }
    }
}
@Composable
fun SupplierScreen() {
    Column(Modifier.fillMaxSize().padding(20.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        Spacer(Modifier.height(40.dp))
        Text("Supplier Panel", fontSize = 26.sp, fontWeight = FontWeight.Bold)
        Text("com.budgetdost.supplier", color = Color.Gray, fontSize = 12.sp)
        Spacer(Modifier.height(30.dp))
        Button(onClick = {}, Modifier.fillMaxWidth().height(55.dp), colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFFFF6B00))) {
            Text("Add New Product", color = Color.White)
        }
        Spacer(Modifier.height(10.dp))
        Text("Yahan se product add hoga - Real Supplier App", color = Color.Gray)
    }
}
