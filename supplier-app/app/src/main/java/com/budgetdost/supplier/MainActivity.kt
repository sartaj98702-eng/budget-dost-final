package com.budgetdost.supplier
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material.*
import androidx.compose.runtime.*

class MainActivity : ComponentActivity() {
 override fun onCreate(savedInstanceState: Bundle?) {
  super.onCreate(savedInstanceState)
  setContent {
   var showAdd by remember{ mutableStateOf(false) }
   if(showAdd) AddProductScreen() else {
    Button(onClick={showAdd=true}){ Text("Add Product") }
   }
  }
 }
}
