package com.budgetdost

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.budgetdost.homepatch.HomePatch

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            HomePatch()
        }
    }
    
    fun startPayment(amount: Int) {
        // Razorpay payment baad me add karenge
    }
}
