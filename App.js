import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, Image, FlatList, StyleSheet, Alert, Linking, Modal } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

// ===== SETTING - ADMIN SE BAAD ME BADAL SAKTA HAI =====
const ADMIN_WHATSAPP = "919973722704"; // Admin Help Number - Yaha apna number daal dena
const DELIVERY_CHARGE = 90; // 40 + 50
const PLATFORM_FEE = 10;
const TEST_OTP = "123456"; // TESTING KE LIYE - Real me ye hat jayega

const CATEGORIES = ["All","Fashion","Electronics","Electric","Hardware","Phone","Bike Battery","Scooty","Home","Beauty","Kirana","Other"];

const DEMO_PRODUCTS = [
  { id: '1', name: 'Men Stylish Shirt', price: 499, oldPrice: 999, category: 'Fashion', img: 'https://via.placeholder.com/300x300/0B3D91/FFFFFF?text=Shirt', rating: '4.5' },
  { id: '2', name: 'Wireless Earbuds', price: 799, oldPrice: 1499, category: 'Electronics', img: 'https://via.placeholder.com/300x300/FF6B00/FFFFFF?text=Earbuds', rating: '4.4' },
  { id: '3', name: 'LED Bulb Pack of 4', price: 299, oldPrice: 599, category: 'Electric', img: 'https://via.placeholder.com/300x300/0B3D91/FFFFFF?text=Bulb', rating: '4.3' },
  { id: '4', name: 'Drill Machine', price: 1299, oldPrice: 2499, category: 'Hardware', img: 'https://via.placeholder.com/300x300/FF6B00/FFFFFF?text=Drill', rating: '4.6' },
  { id: '5', name: 'Smartphone Cover', price: 199, oldPrice: 399, category: 'Phone', img: 'https://via.placeholder.com/300x300/0B3D91/FFFFFF?text=Cover', rating: '4.2' },
  { id: '6', name: 'Bike Battery 12V', price: 1899, oldPrice: 2999, category: 'Bike Battery', img: 'https://via.placeholder.com/300x300/FF6B00/FFFFFF?text=Battery', rating: '4.7' },
];

export default function App() {
  const [screen, setScreen] = useState('login');
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [user, setUser] = useState(null);
  const [search, setSearch] = useState('');
  const [pin, setPin] = useState('');
  const [cat, setCat] = useState('All');
  const [cart, setCart] = useState([]);
  const [address, setAddress] = useState('');
  const [showAddressModal, setShowAddressModal] = useState(false);
  const [tempAddress, setTempAddress] = useState('');
  const [payMethod, setPayMethod] = useState('COD');

  useEffect(()=>{ loadSaved(); },[]);
  const loadSaved = async()=>{
    const u = await AsyncStorage.getItem('bd_user');
    const a = await AsyncStorage.getItem('bd_address');
    const c = await AsyncStorage.getItem('bd_cart');
    if(u) { setUser(JSON.parse(u)); setScreen('home'); }
    if(a) setAddress(a);
    if(c) setCart(JSON.parse(c));
  };

  const sendOtp = ()=>{
    if(phone.length!==10){ Alert.alert('Galat Number','10 digit ka number dalo bhai'); return; }
    setOtpSent(true);
    Alert.alert('Testing OTP','Testing ke liye OTP hai: 123456\nReal me SMS se ayega');
  };

  const verifyOtp = async()=>{
    if(otp===TEST_OTP){
      const u = { phone, name: 'Budget Dost User' };
      setUser(u); await AsyncStorage.setItem('bd_user', JSON.stringify(u));
      setScreen('home');
    } else { Alert.alert('Galat OTP','Testing OTP 123456 dalo'); }
  };

  const addToCart = (p)=>{
    const nc=[...cart,p]; setCart(nc); AsyncStorage.setItem('bd_cart', JSON.stringify(nc));
    Alert.alert('Add Ho Gaya', p.name + ' Cart me add ho gaya');
  };

  const saveAddress = async()=>{
    if(!tempAddress){ Alert.alert('Address','Address likho'); return; }
    setAddress(tempAddress); await AsyncStorage.setItem('bd_address', tempAddress);
    setShowAddressModal(false); Alert.alert('Done','Address save ho gaya');
  };

  const total = cart.reduce((s,i)=>s+i.price,0);
  const grandTotal = cart.length? total + DELIVERY_CHARGE + PLATFORM_FEE : 0;

  const filtered = DEMO_PRODUCTS.filter(p=>{
    const mCat = cat==='All' || p.category===cat;
    const mSearch = p.name.toLowerCase().includes(search.toLowerCase());
    return mCat && mSearch;
  });

  // ===== LOGIN SCREEN =====
  if(screen==='login'){
    return(
      <View style={s.center}>
        <View style={s.logoBox}><Text style={s.logoText}>BUDGET{'\n'}DOST</Text></View>
        <Text style={s.sub}>Sab Kuch Sasta, Sab Kuch Apna</Text>
        {!otpSent ? <>
          <TextInput style={s.input} placeholder="Mobile Number - 10 Digit" keyboardType="number-pad" maxLength={10} value={phone} onChangeText={setPhone} />
          <TouchableOpacity style={s.btn} onPress={sendOtp}><Text style={s.btnT}>OTP Bhejo</Text></TouchableOpacity>
        </> : <>
          <Text style={s.small}>OTP bheja gaya {phone} pe{'\n'}Testing OTP: 123456</Text>
          <TextInput style={s.input} placeholder="OTP - 123456" keyboardType="number-pad" maxLength={6} value={otp} onChangeText={setOtp} />
          <TouchableOpacity style={s.btn} onPress={verifyOtp}><Text style={s.btnT}>Login Karo</Text></TouchableOpacity>
          <TouchableOpacity onPress={()=>setOtpSent(false)}><Text style={s.link}>Number Badalna Hai?</Text></TouchableOpacity>
        </>}
        <TouchableOpacity onPress={()=>Linking.openURL(`https://wa.me/${ADMIN_WHATSAPP}?text=Help chahiye Budget Dost`)}><Text style={s.link}>Help Chahiye? Admin WhatsApp</Text></TouchableOpacity>
      </View>
    );
  }

  // ===== CART SCREEN =====
  if(screen==='cart'){
    return(
      <View style={s.flex}>
        <View style={s.header}><Text style={s.hTitle}>Mera Cart ({cart.length})</Text></View>
        <ScrollView style={s.pad}>
          {cart.length===0 ? <Text style={s.empty}>Cart khaali hai bhai. Pehle product add karo.</Text> :
          cart.map((it,idx)=>(
            <View key={idx} style={s.cartItem}><Image source={{uri: it.img}} style={s.cartImg}/><View style={{flex:1}}><Text style={s.pName}>{it.name}</Text><Text style={s.price}>₹{it.price}</Text></View><TouchableOpacity onPress={()=>{ const nc=cart.filter((_,i)=>i!==idx); setCart(nc); AsyncStorage.setItem('bd_cart', JSON.stringify(nc)); }}><Text style={{color:'red',fontWeight:'bold'}}>X</Text></TouchableOpacity></View>
          ))}
          <View style={s.bill}>
            <Text style={s.billRow}>Product Total: ₹{total}</Text>
            <Text style={s.billRow}>Delivery Charge (40+50): ₹{DELIVERY_CHARGE}</Text>
            <Text style={s.billRow}>Platform Fee: ₹{PLATFORM_FEE}</Text>
            <Text style={s.totalRow}>Total: ₹{grandTotal}</Text>
          </View>
          <Text style={s.label}>Delivery Address</Text>
          <TouchableOpacity style={s.addrBox} onPress={()=>{setTempAddress(address); setShowAddressModal(true);}}><Text>{address || 'Address Add Karo - Yaha Tap Karo'}</Text></TouchableOpacity>
          <Text style={s.label}>Payment Method</Text>
          <TouchableOpacity style={[s.payBox, payMethod==='COD' && s.payActive]} onPress={()=>setPayMethod('COD')}><Text style={s.payT}>💵 Cash on Delivery</Text></TouchableOpacity>
          <TouchableOpacity style={[s.payBox, payMethod==='ONLINE' && s.payActive]} onPress={()=>setPayMethod('ONLINE')}><Text style={s.payT}>💳 Online Payment - Razorpay</Text></TouchableOpacity>
          <TouchableOpacity style={s.btn} onPress={()=>{ if(!address){Alert.alert('Address','Pehle address add karo'); return;} if(cart.length===0){Alert.alert('Cart','Cart khaali hai'); return;} Alert.alert('Order Confirm', payMethod==='COD' ? `COD Order Done! Total ₹${grandTotal} - Courier ko dena hai` : `Testing me Online Payment Demo hai. Real me Razorpay khulega. Total ₹${grandTotal}`); setCart([]); AsyncStorage.removeItem('bd_cart'); setScreen('home'); }}><Text style={s.btnT}>Order Karo - ₹{grandTotal}</Text></TouchableOpacity>
        </ScrollView>
        <View style={s.bottom}><TouchableOpacity onPress={()=>setScreen('home')}><Text style={s.bT}>🏠 Home</Text></TouchableOpacity><TouchableOpacity onPress={()=>setScreen('cart')}><Text style={[s.bT,s.bActive]}>🛒 Cart</Text></TouchableOpacity><TouchableOpacity onPress={()=>setScreen('profile')}><Text style={s.bT}>👤 Profile</Text></TouchableOpacity></View>
      </View>
    );
  }

  // ===== PROFILE SCREEN =====
  if(screen==='profile'){
    return(
      <View style={s.flex}>
        <View style={s.header}><Text style={s.hTitle}>Meri Profile</Text></View>
        <ScrollView style={s.pad}>
          <View style={s.profileCard}><Text style={s.pBig}>👤</Text><Text style={s.pName}>{user?.name}</Text><Text>+91 {user?.phone}</Text><Text style={s.small}>Budget Dost Member</Text></View>
          <Text style={s.label}>Mera Address</Text>
          <TouchableOpacity style={s.addrBox} onPress={()=>{setTempAddress(address); setShowAddressModal(true);}}><Text>{address || 'Address Add Karo'}</Text></TouchableOpacity>
          <TouchableOpacity style={s.menu} onPress={()=>Linking.openURL(`https://wa.me/${ADMIN_WHATSAPP}`)}><Text>💬 Help - Admin WhatsApp</Text></TouchableOpacity>
          <TouchableOpacity style={s.menu} onPress={()=>Alert.alert('My Orders','Testing me order history yaha ayega')}><Text>📦 My Orders</Text></TouchableOpacity>
          <TouchableOpacity style={[s.btn,{backgroundColor:'red'}]} onPress={async()=>{ await AsyncStorage.removeItem('bd_user'); setScreen('login'); setUser(null); }}><Text style={s.btnT}>Logout</Text></TouchableOpacity>
        </ScrollView>
        <View style={s.bottom}><TouchableOpacity onPress={()=>setScreen('home')}><Text style={s.bT}>🏠 Home</Text></TouchableOpacity><TouchableOpacity onPress={()=>setScreen('cart')}><Text style={s.bT}>🛒 Cart</Text></TouchableOpacity><TouchableOpacity onPress={()=>setScreen('profile')}><Text style={[s.bT,s.bActive]}>👤 Profile</Text></TouchableOpacity></View>
      </View>
    );
  }

  // ===== HOME SCREEN =====
  return(
    <View style={s.flex}>
      <View style={s.header}><Text style={s.hTitle}>BUDGET DOST</Text><Text style={{color:'#fff'}}>Araria • All India</Text></View>
      <ScrollView style={s.pad}>
        <Text style={s.label}>🔍 Product Search</Text>
        <TextInput style={s.search} placeholder="Product dhoondo - Shirt, Earbuds..." value={search} onChangeText={setSearch} />
        <Text style={s.label}>📍 PIN Code Search</Text>
        <TextInput style={s.search} placeholder="PIN Code - Jaise 854311" keyboardType="number-pad" maxLength={6} value={pin} onChangeText={setPin} />
        <TouchableOpacity style={s.addrBox} onPress={()=>{setTempAddress(address); setShowAddressModal(true);}}><Text>📍 {address ? address.slice(0,40)+'...' : 'Address Add / Change Karo'}</Text></TouchableOpacity>
        <Text style={s.label}>Categories - Sab Kuch</Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>{CATEGORIES.map(c=>(<TouchableOpacity key={c} style={[s.chip, cat===c && s.chipActive]} onPress={()=>setCat(c)}><Text style={cat===c ? {color:'#fff',fontWeight:'bold'} : {}}>{c}</Text></TouchableOpacity>))}</ScrollView>
        <Text style={s.label}>🔥 Aaj ke Deals</Text>
        {filtered.map(p=>(
          <View key={p.id} style={s.card}>
            <Image source={{uri: p.img}} style={s.cardImg}/>
            <View style={{flex:1, paddingLeft:10}}><Text style={s.pName}>{p.name}</Text><Text>⭐ {p.rating} | {p.category}</Text><Text><Text style={s.price}>₹{p.price} </Text><Text style={s.old}>₹{p.oldPrice}</Text></Text><Text style={s.small}>Delivery ₹90 + Platform ₹10 | COD Available</Text>
            <View style={{flexDirection:'row', marginTop:8}}><TouchableOpacity style={s.smallBtn} onPress={()=>addToCart(p)}><Text style={{color:'#fff',fontWeight:'bold'}}>Add to Cart</Text></TouchableOpacity><TouchableOpacity style={[s.smallBtn,{backgroundColor:'#FF6B00'}]} onPress={()=>{addToCart(p); setScreen('cart');}}><Text style={{color:'#fff',fontWeight:'bold'}}>Buy Now</Text></TouchableOpacity></View></View>
          </View>
        ))}
        {filtered.length===0 && <Text style={s.empty}>Koi product nahi mila. Doosra naam try karo.</Text>}
        <TouchableOpacity style={s.help} onPress={()=>Linking.openURL(`https://wa.me/${ADMIN_WHATSAPP}?text=Help chahiye`)}><Text style={{color:'#fff',fontWeight:'bold',textAlign:'center'}}>💬 Help - Admin WhatsApp</Text></TouchableOpacity>
        <Text style={s.smallCenter}>Supplier ka Address / Number customer ko kabhi nahi dikhega.</Text>
      </ScrollView>
      <View style={s.bottom}><TouchableOpacity onPress={()=>setScreen('home')}><Text style={[s.bT,s.bActive]}>🏠 Home</Text></TouchableOpacity><TouchableOpacity onPress={()=>setScreen('cart')}><Text style={s.bT}>🛒 Cart ({cart.length})</Text></TouchableOpacity><TouchableOpacity onPress={()=>setScreen('profile')}><Text style={s.bT}>👤 Profile</Text></TouchableOpacity></View>
      <Modal visible={showAddressModal} transparent animationType="slide"><View style={s.modalBg}><View style={s.modal}><Text style={s.label}>Address Add / Change</Text><TextInput style={[s.input,{height:100, textAlignVertical:'top'}]} placeholder="Poora Address - Ghar, Gali, Gaon, District, PIN" multiline value={tempAddress} onChangeText={setTempAddress} /><TouchableOpacity style={s.btn} onPress={saveAddress}><Text style={s.btnT}>Save Address</Text></TouchableOpacity><TouchableOpacity onPress={()=>setShowAddressModal(false)}><Text style={s.link}>Band Karo</Text></TouchableOpacity></View></View></Modal>
    </View>
  );
}

const s = StyleSheet.create({
  flex:{flex:1,backgroundColor:'#F5F5F5'}, pad:{padding:12}, center:{flex:1,justifyContent:'center',padding:20,backgroundColor:'#fff'},
  logoBox:{backgroundColor:'#0B3D91',padding:20,borderRadius:15,alignSelf:'center',marginBottom:10}, logoText:{color:'#fff',fontSize:28,fontWeight:'900',textAlign:'center'}, sub:{textAlign:'center',marginBottom:20,color:'#666'},
  input:{borderWidth:1,borderColor:'#ddd',borderRadius:10,padding:14,marginVertical:8,backgroundColor:'#fff'}, btn:{backgroundColor:'#0B3D91',padding:15,borderRadius:10,marginVertical:10}, btnT:{color:'#fff',textAlign:'center',fontWeight:'bold',fontSize:16}, link:{color:'#0B3D91',textAlign:'center',marginTop:10,fontWeight:'bold'}, small:{textAlign:'center',color:'#666',marginVertical:8}, smallCenter:{textAlign:'center',color:'#888',marginVertical:10},
  header:{backgroundColor:'#0B3D91',padding:15,paddingTop:35}, hTitle:{color:'#fff',fontSize:20,fontWeight:'900'},
  label:{fontWeight:'bold',marginTop:12,marginBottom:6}, search:{backgroundColor:'#fff',borderRadius:10,padding:12,borderWidth:1,borderColor:'#ddd'},
  addrBox:{backgroundColor:'#E8F0FF',padding:12,borderRadius:10,marginVertical:8}, chip:{backgroundColor:'#fff',paddingHorizontal:14,paddingVertical:8,borderRadius:20,marginRight:8,borderWidth:1,borderColor:'#ddd'}, chipActive:{backgroundColor:'#0B3D91'},
  card:{backgroundColor:'#fff',borderRadius:12,padding:10,marginVertical:6,flexDirection:'row'}, cardImg:{width:90,height:90,borderRadius:10}, pName:{fontWeight:'bold',fontSize:15}, price:{color:'#0B3D91',fontWeight:'bold',fontSize:16}, old:{textDecorationLine:'line-through',color:'#999'},
  smallBtn:{backgroundColor:'#0B3D91',padding:8,paddingHorizontal:12,borderRadius:8,marginRight:8}, empty:{textAlign:'center',marginVertical:20,color:'#888'},
  bottom:{flexDirection:'row',justifyContent:'space-around',backgroundColor:'#fff',padding:14,borderTopWidth:1,borderTopColor:'#eee'}, bT:{fontSize:15}, bActive:{color:'#0B3D91',fontWeight:'bold'},
  cartItem:{backgroundColor:'#fff',padding:10,borderRadius:10,marginVertical:5,flexDirection:'row',alignItems:'center'}, cartImg:{width:60,height:60,borderRadius:8,marginRight:10},
  bill:{backgroundColor:'#fff',padding:12,borderRadius:10,marginVertical:10}, billRow:{paddingVertical:3}, totalRow:{fontWeight:'bold',fontSize:16,marginTop:6,borderTopWidth:1,borderTopColor:'#eee',paddingTop:6},
  payBox:{backgroundColor:'#fff',padding:14,borderRadius:10,marginVertical:5,borderWidth:1,borderColor:'#ddd'}, payActive:{borderColor:'#0B3D91',borderWidth:2,backgroundColor:'#E8F0FF'}, payT:{fontWeight:'bold'},
  profileCard:{backgroundColor:'#fff',padding:20,borderRadius:12,alignItems:'center',marginBottom:10}, pBig:{fontSize:40}, menu:{backgroundColor:'#fff',padding:14,borderRadius:10,marginVertical:5},
  help:{backgroundColor:'#25D366',padding:14,borderRadius:10,marginVertical:12}, modalBg:{flex:1,backgroundColor:'rgba(0,0,0,0.5)',justifyContent:'flex-end'}, modal:{backgroundColor:'#fff',padding:20,borderTopLeftRadius:20,borderTopRightRadius:20}
});
