package com.budgetdost.homepatch

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun HomePatch() {
    Column(modifier = Modifier.fillMaxSize().background(Color(0xFFF8F9FF)).padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
            Text("Budget Dost ", fontWeight = FontWeight.Bold, fontSize = 22.sp)
            Box(Modifier.background(Color(0xFFFF6B00), RoundedCornerShape(4.dp)).padding(horizontal = 6.dp, vertical = 2.dp)) { Text("SR", color = Color.White, fontSize = 11.sp, fontWeight = FontWeight.Bold) }
            Spacer(Modifier.weight(1f))
            Icon(Icons.Default.Favorite, null, tint = Color(0xFF1A4AB9), modifier = Modifier.size(28.dp))
        }
        Spacer(Modifier.height(16.dp))
        Row(Modifier.fillMaxWidth().background(Color(0xFFD6E6FF), RoundedCornerShape(12.dp)).padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.LocationOn, null, tint = Color(0xFFFF6B00))
            Text(" Deliver to 110001", fontWeight = FontWeight.Medium)
            Spacer(Modifier.weight(1f))
            Text("Change >", color = Color(0xFFFF6B00), fontWeight = FontWeight.Bold)
        }
        Spacer(Modifier.height(12.dp))
        Box(Modifier.fillMaxWidth().background(Color.White, RoundedCornerShape(12.dp)).padding(14.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.Search, null, tint = Color(0xFFFF6B00))
                Spacer(Modifier.width(8.dp))
                Text("Search for products, brands & more", color = Color.Gray, fontSize = 14.sp)
            }
        }
        Spacer(Modifier.height(20.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            repeat(6) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Box(Modifier.size(48.dp).background(if (it % 2 == 0) Color(0xFF1A4AB9) else Color(0xFFFF6B00), CircleShape), contentAlignment = Alignment.Center) {
                        Icon(Icons.Default.ShoppingCart, null, tint = Color.White, modifier = Modifier.size(24.dp))
                    }
                    Spacer(Modifier.height(4.dp))
                    Text(listOf("Groceries","Fashion","Electro","Home","Beauty","Deals")[it], fontSize = 10.sp)
                }
            }
        }
        Spacer(Modifier.height(16.dp))
        Box(Modifier.fillMaxWidth().background(Brush.horizontalGradient(listOf(Color(0xFF1A4AB9), Color(0xFFFF6B00))), RoundedCornerShape(12.dp)).padding(16.dp)) {
            Text("25% OFF - First Order • Min ₹499", color = Color.White, fontWeight = FontWeight.Bold)
        }
        Spacer(Modifier.height(60.dp))
        Box(Modifier.size(140.dp).background(Color(0xFFE3F2FD), CircleShape), contentAlignment = Alignment.Center) {
            Icon(Icons.Default.Search, null, modifier = Modifier.size(80.dp), tint = Color(0xFF90A4AE))
        }
        Spacer(Modifier.height(20.dp))
        Text("No Products Yet", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Color(0xFF1A237E))
        Spacer(Modifier.height(10.dp))
        Text("Abhi koi product nahi hai.\nSupplier jab product add karega tab yahan dikhega.\nCheck back soon.", textAlign = TextAlign.Center, color = Color.Gray, fontSize = 13.sp, lineHeight = 18.sp)
    }
}
