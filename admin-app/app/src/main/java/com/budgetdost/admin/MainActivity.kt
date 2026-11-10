package com.budgetdost.admin
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

class MainActivity : ComponentActivity() {
 override fun onCreate(savedInstanceState: Bundle?) {
  super.onCreate(savedInstanceState)
  setContent {
   Column(Modifier.padding(20.dp)){
    Text("BudgetDost Admin", style=MaterialTheme.typography.h5)
    Spacer(Modifier.height(20.dp))
    Button(onClick={}, Modifier.fillMaxWidth()){ Text("View All Orders") }
    Spacer(Modifier.height(10.dp))
    Button(onClick={}, Modifier.fillMaxWidth()){ Text("View Suppliers") }
    Spacer(Modifier.height(10.dp))
    Button(onClick={}, Modifier.fillMaxWidth()){ Text("View Customers") }
   }
  }
 }
}
