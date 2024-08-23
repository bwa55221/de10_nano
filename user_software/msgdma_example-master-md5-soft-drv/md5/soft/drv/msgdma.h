#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/dma-mapping.h>
#include <linux/interrupt.h>
#include <linux/slab.h>
#include <linux/cdev.h>
#include <linux/platform_device.h>
#include <linux/of_address.h>
#include <linux/uaccess.h>
#include <linux/interrupt.h>
#include <linux/wait.h>
#include <asm/io.h>

#define DEV_NAME            "msgdma"

#define MSGDMA_MAP_SIZE         0x30
#define MSGDMA1_OFFSET          0x40

#define MSGDMA_MAX_TX_LEN       (1 << 12) // 4KB
#define DMA_BUF_SIZE            (1 << 20) //1MB

#define TX_TIMEOUT              HZ // 1 second

typedef u32 volatile reg_t;

#pragma pack(1)
struct msgdma_reg {
    /* CSR port Registers */
    reg_t csr_status;
    reg_t csr_ctrl;
    reg_t csr_fill_lvl;
    reg_t csr_resp_fill_lvl;
    reg_t csr_seq_num;
    reg_t csr_comp_config1;
    reg_t csr_comp_config2;
    reg_t csr_comp_info;

    /* Descriptor port registers (standard format) */
    reg_t desc_read_addr;
    reg_t desc_write_addr;
    reg_t desc_len;
    reg_t desc_ctrl;

    /* Response port registers */
    reg_t resp_bytes_transferred;
    reg_t resp_status; 
};
#pragma pack()

/* MSGDMA Register bit fields */
enum STATUS {
    IRQ                 = (1 << 9),
    STOPPED_EARLY_TERM  = (1 << 8),
    STOPPED_ON_ERR      = (1 << 7),
    RESETTING           = (1 << 6),
    STOPPED             = (1 << 5),
    RESP_BUF_FULL       = (1 << 4),
    RESP_BUF_EMPTY      = (1 << 3),
    DESCR_BUF_FULL      = (1 << 2),
    DESCR_BUF_EMTPY     = (1 << 1),
    BUSY                = (1 << 0),
};

enum CONTROL {
    STOP_DESCR          = (1 << 5),
    GLOBAL_INT_EN_MASK  = (1 << 4),
    STOP_ON_EARLY_TERM  = (1 << 3),
    STOP_ON_ERROR       = (1 << 2),
    RESET_DISPATCHER    = (1 << 1),
    STOP_DISPATCHER     = (1 << 0),
};

enum DESC_CTRL {
    GO                  = (1 << 31),
    EARLY_DONE_EN       = (1 << 24),
    TX_ERR_IRQ_EN       = (1 << 16),
    EARLY_TERM_IRQ_EN   = (1 << 15),
    TX_COMPLETE_IRQ_EN  = (1 << 14),
    END_ON_EOP          = (1 << 12),
    PARK_WR             = (1 << 11),
    PARK_RD             = (1 << 10),
    GEN_EOP             = (1 << 9),
    GEN_SOP             = (1 << 8),
    // TODO : TX CHAN
};

/* Driver private data */
struct msgdma_data {
    dev_t dev_id;
    struct cdev cdev;

    struct msgdma_reg *msgdma0_reg;
    struct msgdma_reg *msgdma1_reg;

    int msgdma0_irq;
    int msgdma1_irq;

    void *dma_buf_wr;
    void *dma_buf_rd;
    dma_addr_t dma_buf_wr_handle;
    dma_addr_t dma_buf_rd_handle;

    wait_queue_head_t wr_complete_wq;
    wait_queue_head_t rd_complete_wq;
    int wr_in_progress;
    int rd_in_progress;
};

/* Function declarations */
static int
msgdma_open(struct inode *node, struct file *f);
static int
msgdma_release(struct inode *node, struct file *f);
static ssize_t
msgdma_read(struct file *f, char __user *ubuf, size_t len, loff_t *off);
static ssize_t
msgdma_write(struct file *f, const char __user *ubuf, size_t len, loff_t *off);

static int
msgdma_probe(struct platform_device *pdev);
static int
msgdma_remove(struct platform_device *pdev);

static const struct file_operations msgdma_fops = {
    .owner      = THIS_MODULE,
    .open       = msgdma_open,
    .release    = msgdma_release,
    .read       = msgdma_read,
    .write      = msgdma_write
};

static const struct of_device_id msgdma_of_match[] = {
    {.compatible = "msgdma_test" },
    {}
};

static struct platform_driver msgdma_driver = {
    .probe = msgdma_probe,
    .remove = msgdma_remove,
    .driver = {
        .name = DEV_NAME,
        .of_match_table = msgdma_of_match,
    },
};
