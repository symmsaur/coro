extern int call_pointer(void (*func)(void*), void* context);

void add_2(void* value_raw) {
    int* value = (int*)value_raw;
    *value += 2;
}

int main() {
    int res = 40;
    void* context = (void*)&res;
    call_pointer(&add_2, context);
    return res;
}
