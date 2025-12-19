#include <efi.h>
#include <efilib.h>

extern void kernel_main();

EFI_STATUS EFIAPI efi_main(EFI_HANDLE image, EFI_SYSTEM_TABLE *st) {

    EFI_INPUT_KEY key;
    EFI_STATUS status;
    UINTN map_size = 0, map_key, desc_size;


    UINT32 desc_ver;
    void *mem_map = NULL;
    if (st == NULL) return EFI_INVALID_PARAMETER;


    InitializeLib(image, st);
    Print(L"[Step 2] UEFI library initialized successfully.\n");

    Print(L"[Step 3] Hello from UEFI!\n");

    Print(L"RNL (Reao's Not Linux :3 )\n");

    Print(L"[Step 4] Press any key to exit...\n");

    st->ConIn->Reset(st->ConIn, FALSE);

    while (st->ConIn->ReadKeyStroke(st->ConIn, &key) != EFI_SUCCESS) {}

    Print(L"[Step 5] Key pressed. Exiting boot services.\n");

    status = st->BootServices->GetMemoryMap(&map_size, mem_map, &map_key, &desc_size, &desc_ver);
    
    if (status == EFI_BUFFER_TOO_SMALL) {

        mem_map = AllocatePool(map_size);

        status = st->BootServices->GetMemoryMap(&map_size, mem_map, &map_key, &desc_size, &desc_ver);

    }
    if (EFI_ERROR(status)) {

        Print(L"Failed to get memory map.\n");

        return status;
    }
    status = st->BootServices->ExitBootServices(image, map_key);
    if (EFI_ERROR(status)) {
        Print(L"ExitBootServices failed.\n");

        return status;
    }
    kernel_main();
    return EFI_SUCCESS;

}

