package com.example.marco_preview

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.marco_preview.models.User
import com.example.marco_preview.ui.theme.Marco_PreviewTheme
import com.airbnb.lottie.compose.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {

    var userList = mutableStateListOf<User>() // Lista de usuarios

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Llamada a la API para obtener la lista de usuarios
        CoroutineScope(Dispatchers.IO).launch {
            val users = RetrofitInstance.api.getUsers()
            userList.addAll(users)
        }

        // Configuramos la UI de la aplicación
        setContent {
            Marco_PreviewTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    var selectedUser by remember { mutableStateOf<User?>(null) }

                    if (selectedUser == null) {
                        UserListScreen(userList) { user ->
                            selectedUser = user
                        }
                    } else {
                        UserDetailScreen(user = selectedUser!!) {
                            selectedUser = null // Vuelve a la lista cuando se hace clic en "Volver"
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun UserListScreen(users: List<User>, onUserClick: (User) -> Unit) {
    val context = LocalContext.current // Obtener el contexto

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        // Lista de usuarios
        LazyColumn(
            modifier = Modifier
                .weight(1f) // Para permitir que el botón se coloque después de la lista
                .fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(users) { user ->
                UserCard(user = user, onClick = { onUserClick(user) })
            }
        }

        // Botón fuera de la lista
        Button(
            onClick = {
                // Navegar a otra actividad o realizar alguna acción
                val intent = Intent(context, SecondActivity::class.java)
                context.startActivity(intent)
            },
            modifier = Modifier.align(Alignment.CenterHorizontally)
        ) {
            Text(text = "Navegar a otra pantalla")
        }
    }
}

@Composable
fun UserCard(user: User, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .height(120.dp)
            .clickable { onClick() }, // Agregamos la acción de clic
        elevation = 8.dp,
        shape = RoundedCornerShape(16.dp)
    ) {
        Row(
            modifier = Modifier
                .background(MaterialTheme.colors.surface)
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = user.name,
                    fontWeight = FontWeight.Bold,
                    fontSize = 20.sp,
                    color = MaterialTheme.colors.primary
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = user.email,
                    fontSize = 16.sp,
                    color = Color.Gray
                )
            }

        }
    }
}

@Composable
fun UserDetailScreen(user: User, onBackClick: () -> Unit) {

    val context = LocalContext.current
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(text = "User Details") },
                backgroundColor = MaterialTheme.colors.primary,
                contentColor = Color.White,
                elevation = 12.dp
            )
        },
        content = { paddingValues ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp)
                    .padding(paddingValues),
                horizontalAlignment = Alignment.CenterHorizontally // Centrar el contenido
            ) {
                // Agregar la animación Lottie
                val composition by rememberLottieComposition(LottieCompositionSpec.RawRes(R.raw.user))
                val animationState by animateLottieCompositionAsState(
                    composition = composition,
                    iterations = LottieConstants.IterateForever // Repetir la animación indefinidamente
                )

                // Mostramos la animación Lottie
                LottieAnimation(
                    reverseOnRepeat = false,
                    composition = composition,

                    modifier = Modifier.size(200.dp) // Tamaño de la animación
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Mostrar los detalles del usuario
                Text(
                    text = "Name: ${user.name}",
                    style = MaterialTheme.typography.h5,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                Text(
                    text = "Username: ${user.username}",
                    style = MaterialTheme.typography.body1,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                Text(
                    text = "Email: ${user.email}",
                    style = MaterialTheme.typography.body1,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                Text(
                    text = "Phone: ${user.phone}",
                    style = MaterialTheme.typography.body1,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                Text(
                    text = "Website: ${user.website}",
                    style = MaterialTheme.typography.body1,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                Text(
                    text = "Company: ${user.company.name}",
                    style = MaterialTheme.typography.body1,
                    modifier = Modifier.padding(bottom = 8.dp)
                )


                Spacer(modifier = Modifier.height(16.dp))
                Button(
                    onClick = onBackClick, // Cuando se hace clic, volvemos a la lista
                    modifier = Modifier.align(Alignment.CenterHorizontally)
                ) {
                    Text(text = "Volver")
                }

            }
        }
    )
}
