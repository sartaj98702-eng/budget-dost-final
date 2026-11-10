package com.budgetdost.supplier
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

class MainActivity : ComponentActivity() {
 override fun onCreate(savedInstanceState: Bundle?) {
  super.onCreate(savedInstanceState)
  setContent {
   var screen by remember{ mutableStateOf("home") }
   when(screen){
    "add" -> AddProductScreen()
    "orders" -> OrderListScreen()
    else -> Column(Modifier.padding(20.dp)){
     Button(onClick={screen="add"}, Modifier.fillMaxWidth()){ Text("Add Product") }
     Spacer(Modifier.height(10.dp))
     Button(onClick={screen="orders"}, Modifier.fillMaxWidth()){ Text("View Orders") }
    }
   }
  }
 }
}
