package com.budgetdost.supplier
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun AddProductScreen(){
 var name by remember{ mutableStateOf("") }
 var price by remember{ mutableStateOf("") }
 Column(Modifier.padding(16.dp)){
   Text("Add Product")
   Spacer(Modifier.height(10.dp))
   OutlinedTextField(value=name, onValueChange={name=it}, label={Text("Name")}, modifier=Modifier.fillMaxWidth())
   OutlinedTextField(value=price, onValueChange={price=it}, label={Text("Price")}, modifier=Modifier.fillMaxWidth())
   Spacer(Modifier.height(10.dp))
   Button(onClick={}, modifier=Modifier.fillMaxWidth()){ Text("Save") }
 }
}
