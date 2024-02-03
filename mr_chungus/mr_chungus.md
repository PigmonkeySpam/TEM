

so we want:
1) always ensure aleast 10K in production storage
2) move stuff over 11K into Mr Chungus

- stuff can only be moved in a single stack size

---
1) loop through managed resource list
    - getItem() if `size` > 11K add to extract list
    - extract 64 from `mr_chungus` 
        - if this fails or is less than 64 `end`



block_refinedstorage_interface