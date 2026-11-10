package com.budgetdost

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.razorpay.Checkout
import org.json.JSONObject

class MainActivity : AppCompatActivity() {
    private val RAZORPAY_KEY = "rzp_test_Tve76IZWuKemRw"
    private val HELPLINE = "9973722704"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Checkout.preload(applicationContext)
    }

    fun startPayment(amount: Int) {
        val checkout = Checkout()
        checkout.setKeyID(RAZORPAY_KEY)
        val options = JSONObject()
        options.put("name", "Budget Dost")
        options.put("description", "Saree Order Payment")
        options.put("amount", amount * 100)
        options.put("currency", "INR")
        options.put("prefill.contact", HELPLINE)
        checkout.open(this, options)
    }
}
