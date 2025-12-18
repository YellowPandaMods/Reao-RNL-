#include <efi.h>
#include <efilib.h>

EFI_STATUS
EFIAPI
efi_main(EFI_HANDLE image, EFI_SYSTEM_TABLE *st) {
    EFI_INPUT_KEY key;

    // Step 0: Check the pointers and stuff
    if (st == NULL) return EFI_INVALID_PARAMETER;
    InitializeLib(image, st);

    // Step 2: Test print it should work
    Print(L"[Step 2] UEFI library initialized successfully.\n");

    // Step 3: Another test for some reason
    Print(L"[Step 3] Hello from UEFI!\n");
    Print(L"RNL (Reao's Not Linux :3 )\n"); // Cute

    // Step 4: Wait for key press safely (after the key press nothing happens TODO: Fix)
    Print(L"[Step 4] Press any key to exit...\n"); //this prints

    st->ConIn->Reset(st->ConIn, FALSE);
    while (st->ConIn->ReadKeyStroke(st->ConIn, &key) != EFI_SUCCESS) {
        // Wait until a key is pressed (it is pressed but nothing happens.. weird ill fix it
    }

    Print(L"[Step 5] Key pressed. Exiting.\n");
    return EFI_SUCCESS;
}

