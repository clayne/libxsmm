/******************************************************************************
* Copyright (c) Intel Corporation - All rights reserved.                      *
* This file is part of the LIBXSMM library.                                   *
*                                                                             *
* For information on the license, see the LICENSE file.                       *
* Further information: https://github.com/libxsmm/libxsmm/                    *
* SPDX-License-Identifier: BSD-3-Clause                                       *
******************************************************************************/
/* Siddharth Rai, Alexander Heinecke (Intel Corp.)
******************************************************************************/
#ifndef GENERATOR_MATELTWISE_RV64_H
#define GENERATOR_MATELTWISE_RV64_H

#include "generator_common.h"
#include "generator_rv64_instructions.h"

LIBXSMM_API_INTERN
libxsmm_blasint libxsmm_generator_mateltwise_rv64_valid_arch_precision( libxsmm_generated_code*           io_generated_code,
                                                                        const libxsmm_meltw_descriptor*   i_mateltwise_desc);

LIBXSMM_API_INTERN
void libxsmm_generator_mateltwise_rv64_kernel( libxsmm_generated_code*         io_generated_code,
                                               const libxsmm_meltw_descriptor* i_mateltw_desc );

LIBXSMM_API_INTERN
void libxsmm_generator_mateltwise_rv64_update_micro_kernel_config_vectorlength( libxsmm_generated_code*           io_generated_code,
                                                                                libxsmm_mateltwise_kernel_config* io_micro_kernel_config,
                                                                                const libxsmm_meltw_descriptor*   i_mateltwise_desc);

LIBXSMM_API_INTERN
void libxsmm_generator_mateltwise_rv64_init_micro_kernel_config_fullvector( libxsmm_generated_code*           io_generated_code,
                                                                            libxsmm_mateltwise_kernel_config* io_micro_kernel_config,
                                                                            const libxsmm_meltw_descriptor*   i_mateltwise_desc);

LIBXSMM_API_INTERN
void libxsmm_generator_meltw_setup_stack_frame_rv64( libxsmm_generated_code*            io_generated_code,
                                                     const libxsmm_meltw_descriptor*    i_mateltwise_desc,
                                                     libxsmm_mateltwise_gp_reg_mapping* i_gp_reg_mapping,
                                                     libxsmm_mateltwise_kernel_config*  i_micro_kernel_config);

LIBXSMM_API_INTERN
void libxsmm_generator_meltw_destroy_stack_frame_rv64( libxsmm_generated_code*                  io_generated_code,
                                                       const libxsmm_meltw_descriptor*          i_mateltwise_desc,
                                                       const libxsmm_mateltwise_kernel_config*  i_micro_kernel_config );

LIBXSMM_API_INTERN
void libxsmm_generator_mateltwise_rv64_kernel( libxsmm_generated_code*         io_generated_code,
                                               const libxsmm_meltw_descriptor* i_mateltw_desc );

#endif /* GENERATOR_MATELTWISE_RV64_H */
